import connect.Config;
import connect.ProcessorFactory;
import connect.TileActivation;

class Test {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        // Load test config
        Config.load("test_config.json");
        
        // List requests
        ProcessorFactory.newFulfillmentProcessor(function(request) {
            trace(request.id + " : " + request.asset.connection.id);
            return new TileActivation("# Hello, world!");
        }).process();

        // Get final time
        var finalTime = Date.now().getTime();

        trace("Total time: " + ((finalTime - initialTime) / 1000) + " secs.");
    }
}
