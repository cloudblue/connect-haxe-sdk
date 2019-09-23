package connect.api;

import tink.http.Header.HeaderField;


class ApiClient {
    public static function getInstance() : ApiClient {
        if (instance == null) {
            instance = new ApiClient();
        }
        return instance;
    }


    /**
        Lists requests for one resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param filters Optional filters.
        @returns an array of anonymous structures with the parsed list of requests.
        @throws String if the request fails.
    **/
    public function list(resource: String, ?filters: QueryParams) : Array<Dynamic> {
        var response = getInstance().syncRequest("GET", resource, filters);
        if (response.status < 400) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
    }


    /**
        Get one resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to get.
        @returns An object with the requested resource.
        @throws String if the request fails.
    **/
    public function get(resource: String, id: String): Dynamic {
        var response = getInstance().syncRequest("GET", resource + "/" + id);
        if (response.status < 400) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
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
        var response = getInstance().syncRequest("PUT", resource + "/" + id, dataStr);
        if (response.status < 400) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
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
        var path = resource
            + (id != null ? "/" + id : "")
            + (suffix != null ? "/" + suffix : "");
        var dataStr = (data != null) ? haxe.Json.stringify(data) : null;
        var response = getInstance().syncRequest("POST", path, dataStr);
        if (response.status < 400) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
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
            ?params: QueryParams, ?data: String) : Response {
        var methods = [
            'GET' => tink.http.Method.GET,
            'PUT' => tink.http.Method.PUT,
            'POST' => tink.http.Method.POST
        ];

        var tinkMethod: tink.http.Method = null;
        try {
            tinkMethod = methods.get(method.toUpperCase());
        } catch (e: Dynamic) {
            throw 'Invalid request method ${method}';
        }

        var stringParams = params != null ? params.toString() : '';
        var response: Response = null;
        tink.http.Client.fetch(Config.getInstance().apiUrl + path + stringParams, {
            method: tinkMethod,
            headers: [new HeaderField('Authorization', Config.getInstance().apiKey)],
            body: data
        }).all().handle(function(o) {
            switch (o) {
                case Success(res):
                    response = new Response(res.header.statusCode, res.body.toString());
                case Failure(res):
                    throw res.toString();
            }
        });
        
        // Wait for async request
        while (response == null) {}

        return response;
    }
    
    
    /*
    private function syncRequest(method: String, path: String,
            ?params: QueryParams, ?data: String) : Response {
        var status:Null<Int> = null;
        var responseBytes = new haxe.io.BytesOutput();

        var http = new haxe.Http(Config.getInstance().apiUrl + path);

        http.addHeader("Authorization", Config.getInstance().apiKey);

        if (params != null) {
            for (name in params.keys()) {
                http.addParameter(name, params.get(name));
            }
        }

        if (data != null) {
            http.setPostData(data);
        }

        http.onStatus = function(status_) { status = status_; };
        http.onError = function(msg) { throw msg; }
        
        http.customRequest(false, responseBytes, null, method.toUpperCase());
        while (status == null) {} // Wait for async request

        return new Response(status, responseBytes.getBytes().toString());
    }
    */


    private function new() {}
}
