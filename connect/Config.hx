package connect;

import connect.Processor.FilterMap;

class Config {
    public var apiUrl(default, null) : String;
    public var apiKey(default, null) : String;
    
    
    public function hasProduct(productId:String) : Bool {
        return products.indexOf(productId) > -1;
    }

    public function getProductsString() : String {
        return this.products.join(",");
    }

    public function syncRequest(method:String, path:String, params:FilterMap) : Response {
        var status:Null<Int> = null;
        var responseBytes = new haxe.io.BytesOutput();

        var http = new haxe.Http(this.apiUrl + path);
        http.addHeader("Authorization", this.apiKey);
        for (name in params.keys()) {
            http.addParameter(name, params[name]);
        }
        http.onStatus = function(status_) { status = status_; };
        http.customRequest(false, responseBytes, null, method.toUpperCase());
        while (status == null) {} // Wait for async request

        return new Response(status, responseBytes.getBytes().toString());
    }
    

    public static function init(apiKey:String, apiUrl:String, products:Array<String>) : Void {
        if (instance == null) {
            instance = new Config();
            instance.setApiUrl(apiUrl);
            instance.setApiKey(apiKey);
            instance.products = products.copy();
        } else {
            throw "Config instance is already initialized.";
        }
    }
    
    public static function load(filename: String) : Void {
        if (instance == null) {
            instance = new Config();
            // TODO: Handle read failure
            var content = sys.io.File.getContent(filename);
            var object = haxe.Json.parse(content);
            // TODO: Use a more robust deserialization
            instance.setApiUrl(object.apiEndpoint);
            instance.setApiKey(object.apiKey);
            instance.products = [object.products];
        } else {
            throw "Config instance is already initialized.";
        }
    }
    
    public static function getInstance() : Config {
        if (instance == null) {
            // TODO: Handle load failure
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
