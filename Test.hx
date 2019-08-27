import connect.Config;
import connect.ProcessorFactory;
import connect.TileActivation;

class Test {
    public static function main() {
        // Load test config
        Config.load("test_config.json");
        
        // List requests
        ProcessorFactory.newFulfillmentProcessor(function(request) {
            trace(request.asset.connection.id);
            return new TileActivation("# Hello, world!");
        }).process();
    }
}
