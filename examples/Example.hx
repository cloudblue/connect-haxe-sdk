import connect.Env;
import connect.Flow;
import connect.Logger;
import connect.Processor;
import connect.api.QueryParams;
import connect.models.Request;

class Example {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        Env.loadConfig('examples/config.json');
        Env.initLogger('examples/log.md', Logger.LEVEL_INFO, null);

        // Define main flow
        var flow = new Flow(null)
            .step('Add dummy data', function(f, input) {
                f.setData('assetId', f.getRequest().asset.id)
                    .setData('connectionId', f.getRequest().asset.connection.id)
                    .setData('productId', f.getRequest().asset.product.id)
                    .setData('status', f.getRequest().status);
                return f.getRequest().id;
            })
            .step('Trace request data', function(f, requestId) {
                Sys.println(requestId
                    + ' : ' + f.getData('assetId')
                    + ' : ' + f.getData('connectionId')
                    + ' : ' + f.getData('productId')
                    + ' : ' + f.getData('status'));
                return null;
            });
            /*
            .step('Approve request', function(f, input) {
                f.getRequest().approveByTemplate('TL-000-000-000');
                f.getRequest().approveByTile('Markdown text');
                return null;
            })
            */

        // Process requests
        new Processor()
            .flow(flow)
            .processRequests(new QueryParams()
                .set('asset.product.id__in', Env.getConfig().getProductsString())
                .set('status', 'pending'));

        // Trace total time
        var finalTime = Date.now().getTime();
        Sys.println('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
