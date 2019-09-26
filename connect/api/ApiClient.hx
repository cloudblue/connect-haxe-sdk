package connect.api;

#if js
import connect.lib.XMLHttpRequestInitializer;
#else
import haxe.io.StringInput;
#end


private typedef Multipart = {
    argname: String,
    filename: String,
    contents: String,
}


class ApiClient {
    public static function getInstance() : ApiClient {
        if (instance == null) {
            instance = new ApiClient();
        }
        return instance;
    }

    /**
        Get a resource if 'id' is specified, or a list of reosurces otherwise.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to get.
        @param suffix Optional path suffix (i.e. "approve").
        @param parse Whether to parse the response as a Json object (default true).
        @returns An object with the requested resource, or a string if parse == false.
        @throws String if the request fails.
    **/
    public function get(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams, parse: Bool = true): Dynamic {
        var response = syncRequest('GET', parsePath(resource, id, suffix), params);
        return checkResponse(response, parse);
    }


    /**
        Put data to one resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to put data on.
        @param data The data object to put (normally the modified resource).
        @returns An object with the modified resource.
        @throws String if the request fails.
    **/
    public function put(resource: String, id: String, data: Dynamic): Dynamic {
        var dataStr = (data != null) ? haxe.Json.stringify(data) : null;
        var response = syncRequest('PUT', parsePath(resource, id), dataStr);
        return checkResponse(response);
    }


    /**
        Post data.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param data The data object to post.
        @returns An object.
        @throws String if the request fails.
    **/
    public function post(resource: String, ?id: String, ?suffix: String, ?data: Dynamic): Dynamic {
        var dataStr = (data != null) ? haxe.Json.stringify(data) : null;
        var response = syncRequest('POST', parsePath(resource, id, suffix), dataStr);
        return checkResponse(response);
    }


    /**
        Post a file using the Content-Type "multipart/form-data".

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param argname Argument name in the request.
        @param filename Name of the file to send.
        @param contents Contents of the file.
        @returns An object.
        @throws String if the request fails.
    **/
    public function postFile(resource: String, ?id: String, ?suffix: String,
        argname: String, filename: String, contents: String): Dynamic {
        var response = syncRequest('POST', parsePath(resource, id, suffix), null, {
            argname: argname,
            filename: filename,
            contents: contents
        });
        return checkResponse(response);
    }


    private static var instance: ApiClient;


    /**
        Sends a synchronous request to Connect.

        @param method The REST method to use (i.e. "GET", "POST", "PUT"...).
        @param path A path to append to the apiUrl of this configuration (i.e. "requests").
        @param params Request query params.
        @param data String encoded post data.
        @returns a Response object with the response status and text
    **/
    private function syncRequest(method: String, path: String,
            ?params: QueryParams, ?data: String, ?multipart: Multipart) : Response {
        #if js
            XMLHttpRequestInitializer.init();

            var url = Config.getInstance().apiUrl + path + params.toString();

            var xhr = new js.html.XMLHttpRequest();
            xhr.open(method.toUpperCase(), url, false);

            xhr.setRequestHeader('Authorization', Config.getInstance().apiKey);

            if (data != null) {
                xhr.send(data);
            } else if (multipart != null) {
                var formData = new js.html.FormData();
                formData.append(multipart.argname, multipart.contents);
                xhr.send(formData);
            } else {
                xhr.send();
            }

            if (xhr.readyState == js.html.XMLHttpRequest.UNSENT) {
                throw xhr.responseText != null
                    ? xhr.responseText
                    : 'Error sending ${method} request to "${url}."';
            }

            return new Response(xhr.status, xhr.responseText);
        #else
            var status:Null<Int> = null;
            var responseBytes = new haxe.io.BytesOutput();

            var http = new haxe.Http(Config.getInstance().apiUrl + path);

            http.setHeader('Authorization', Config.getInstance().apiKey);

            if (params != null) {
                for (name in params.keys()) {
                    http.setParameter(name, params.get(name));
                }
            }

            if (data != null) {
                http.setPostData(data);
            }

            if (multipart != null) {
                http.fileTransfer(
                    multipart.argname,
                    multipart.filename,
                    new StringInput(multipart.contents),
                    multipart.contents.length,
                    'multipart/form-data'
                );
            }

            http.onStatus = function(status_) { status = status_; };
            http.onError = function(msg) { throw msg; }            
            http.customRequest(false, responseBytes, null, method.toUpperCase());

            while (status == null) {} // Wait for async request
            return new Response(status, responseBytes.getBytes().toString());
        #end
    }


    private function parsePath(resource: String, ?id: String, ?suffix: String): String {
        return resource
            + (id != null ? "/" + id : "")
            + (suffix != null ? "/" + suffix : "");
    }


    private function checkResponse(response: Response, parse: Bool = true): Dynamic {
        if (response.status < 400) {
            if (parse) {
                return haxe.Json.parse(response.text);
            } else {
                return response.text;
            }
        } else {
            throw response.text;
        }
    }


    private function new() {}
}
