package connect;

import connect.Processor.FilterMap;

/**
    Configuration singleton that allows communication with the Connect platform.
**/
class Config {
    /**
        Endpoint to interact with Connect API.
    **/
    public var apiUrl(default, null) : String;


    /**
        Authorization key.
    **/
    public var apiKey(default, null) : String;
    
    
    /**
        Tells whether the configuration is setup to process the specified product.

        @param productId The id of the product.
        @returns true if the configuration is setup to process the specified product.
    **/
    public function hasProduct(productId:String) : Bool {
        return products.indexOf(productId) > -1;
    }


    /**
        Get the entire list of products supported by this configuration.

        @returns a comma-separated string with the list of products.
    **/
    public function getProductsString() : String {
        return this.products.join(",");
    }


    /**
        Sends a synchronous request to Connect.

        @param method The REST method to use (i.e. "GET", "POST", "PUT"...).
        @param path A path to append to the apiUrl of this configuration (i.e. "requests").
        @param params A map with string keys and values with the request query params.
        @param data String encoded post data.
        @returns a Response object with the response status and text
    **/
    public function syncRequest(method:String, path:String, ?params:FilterMap, ?data:String) : Response {
        var status:Null<Int> = null;
        var responseBytes = new haxe.io.BytesOutput();

        var http = new haxe.Http(this.apiUrl + path);

        http.addHeader("Authorization", this.apiKey);

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
    

    /**
        Initializes the configuration singleton.

        @param apiUrl Value for the apiUrl property.
        @param apiKey Value for the apiKey property.
        @param products Array of product ids that can be processed with this configuration.
        @throws String if the configuration is already initialized.
    **/
    public static function init(apiUrl:String, apiKey:String, products:Array<String>) : Void {
        if (instance == null) {
            instance = new Config();
            instance.setApiUrl(apiUrl);
            instance.setApiKey(apiKey);
            instance.products = products.copy();
        } else {
            throw "Config instance is already initialized.";
        }
    }
    

    /**
        Initializes the configuration singleton using a JSON file.

        @param filename Name of the configuration JSON file to parse.
        @throws Exception if the file cannot be parsed.
        @throws String if the configuration is already initialized.
    **/
    public static function load(filename: String) : Void {
        if (instance == null) {
            instance = new Config();
            var content = sys.io.File.getContent(filename);
            var object = haxe.Json.parse(content);
            instance.setApiUrl(object.apiEndpoint);
            instance.setApiKey(object.apiKey);
            instance.products = [object.products];
        } else {
            throw "Config instance is already initialized.";
        }
    }
    

    /**
        Returns the singleton instance. If it is not initialized, it tries to initialize it from
        the file "config.json".

        @returns the singleton instance.
        @throws Exception if the instance is not initialized and the file "config.json" cannot be
            parsed.
    **/
    public static function getInstance() : Config {
        if (instance == null) {
            load("config.json");
        }
        return instance;
    }
    
    
    private var products : Array<String>;
    
    
    private static var instance : Config;
    
    
    private function new() {}

    
    private function setApiUrl(apiUrl:String) : Void {
        this.apiUrl = (apiUrl.charAt(apiUrl.length - 1) == "/") ? apiUrl : apiUrl + "/";
    }
    
    
    private function setApiKey(apiKey:String) : Void {
        this.apiKey = (apiKey.indexOf("ApiKey ") == 0) ? apiKey : ("ApiKey " + apiKey);
    }
}
