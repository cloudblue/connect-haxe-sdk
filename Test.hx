import connect.Config;
import connect.api.ConnectApi;

class Test {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        // Load test config
        Config.load('test_config.json');

        // Get Connect API
        var api = ConnectApi.getInstance();
        
        // List requests
        var requests = api.fulfillment.listRequests();
        for (request in requests) {
            trace(request.id + ' : ' + request.asset.connection.id);

            /*
            // Approve by tile
            api.fulfillment.changeRequestStatus(request.id, 'approve', {
                activation_tile: 'Markdown text'
            });

            // Approve by template
            api.fulfillment.changeRequestStatus(request.id, 'approve', {
                template_id: 'TL-000-000-000'
            });
            */
        }

        // Trace total time
        var finalTime = Date.now().getTime();
        trace('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
