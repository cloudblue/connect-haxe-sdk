package connect;

import connect.Processor.FilterMap;


class Connect {
    /**
        Lists all the pending requests.

        @param path Last component of the path (e.g. "requests" for the Fulfillment API).
        @param filters A FilterMap (a map with string keys and values) with the filters.
        @returns an array of anonymous structures with the parsed list of requests.
        @throws String if the request fails.
    **/
    public function listRequests(path:String, filters:FilterMap) : Array<Dynamic> {
        var response = getInstance().syncRequest("GET", path, filters);
        if (response.status == 200) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
    }


    public static function getInstance() : Connect {
        if (instance == null) {
            instance = new Connect();
        }
        return instance;
    }

    private static var instance: Connect;


    private function new() {}


    /**
        Sends a synchronous request to Connect.

        @param method The REST method to use (i.e. "GET", "POST", "PUT"...).
        @param path A path to append to the apiUrl of this configuration (i.e. "requests").
        @param params A map with string keys and values with the request query params.
        @param data String encoded post data.
        @returns a Response object with the response status and text
    **/
    private function syncRequest(method:String, path:String, ?params:FilterMap, ?data:String) : Response {
        var status:Null<Int> = null;
        var responseBytes = new haxe.io.BytesOutput();

        var http = new haxe.Http(Config.getInstance().apiUrl + path);

        http.addHeader("Authorization", Config.getInstance().apiKey);

        if (params != null) {
            for (name in params.keys()) {
                http.addParameter(name, params[name]);
            }
        }

        if (data != null) {
            http.setPostData(data);
        }

        http.onStatus = function(status_) { status = status_; };
        
        http.customRequest(false, responseBytes, null, method.toUpperCase());
        while (status == null) {} // Wait for async request

        return new Response(status, responseBytes.getBytes().toString());
    }
}
