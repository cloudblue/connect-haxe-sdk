import connect.Config;
import connect.ProcessorFactory;
import connect.TileActivation;

class Test {
    public static function main() {
        // Load test config
        Config.load("test_config.json");
        
        // List requests
        var processor = ProcessorFactory.newFulfillmentProcessor();
        processor.onProcessRequest = function(request) {
            trace(request.id);
            return new TileActivation("# Hello, world!");
        };
        processor.process();
    }
}
