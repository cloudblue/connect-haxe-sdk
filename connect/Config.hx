package connect;

class Config {
    public var apiKey(default, null) : String;
    public var apiUrl(default, null) : String;
    
    
    public function hasProduct(productId:String) : Bool {
        return products.indexOf(productId) > -1;
    }
    
    
    public static function init(apiKey:String, apiUrl:String, products:Array<String>) : Bool {
        if (instance == null) {
            instance = new Config();
            instance.apiKey = apiKey;
            instance.apiUrl = apiUrl;
            instance.products = products.copy();
            return true;
        } else {
            return false;
        }
    }
    
    public static function load(filename: String) : Bool {
        if (instance == null) {
            instance = new Config();
            // TODO: Handle read failure
            var content = sys.io.File.getContent(filename);
            var object = haxe.Json.parse(content);
            // TODO: Use a more robust deserialization
            instance.apiKey = object.apiKey;
            instance.apiUrl = object.apiEndpoint;
            instance.products = [object.products];
            return true;
        } else {
            return false;
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
    
    
    private function new() {
    }
}
