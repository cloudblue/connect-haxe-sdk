import connect.Defaults;
import connect.api.QueryParams;
import connect.models.*;

class Example {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        // Load test config
        Defaults.loadConfig('test_config.json');

        // List requests
        var requests = Fulfillment.list(new QueryParams()
            .param('asset.product.id__in', Defaults.getConfig().getProductsString())
            .param('status', 'pending')
        );

        // Trace requests
        for (request in requests) {
            trace(request.id
                + ' : ' + request.asset.id
                + ' : ' + request.asset.connection.id
                + ' : ' + request.asset.product.id
                + ' : ' + request.status);

            /*
            // Approve by tile or template
            request.approveByTemplate('TL-000-000-000');
            request.approveByTile('Markdown text');
            */
        }

        // Trace total time
        var finalTime = Date.now().getTime();
        trace('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
