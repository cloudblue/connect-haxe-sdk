import connect.Config;

class Test {
    public static function main() {
        // Load test config
        Config.load("test_config.json");
        
        // List requests
        var url = Config.getInstance().apiUrl + "requests?status=pending";
        var http = new haxe.Http(url);
        http.onData = function(data) { trace(data); };
        http.request();
    }
}
