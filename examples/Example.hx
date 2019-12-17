import connect.Env;
import connect.Flow;
import connect.Logger;
import connect.Processor;
import connect.api.Query;


class Example {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        Env.loadConfig('examples/config.json');
        Env.initLogger('examples/log.md', Logger.LEVEL_INFO, null);

        // Define main flow
        var flow = new Flow(null)
            .step('Add dummy data', function(f) {
                f.setData('requestId', f.getRequest().id)
                    .setData('assetId', f.getRequest().asset.id)
                    .setData('connectionId', f.getRequest().asset.connection.id)
                    .setData('productId', f.getRequest().asset.product.id)
                    .setData('status', f.getRequest().status);
                return f.getRequest().id;
            })
            .step('Trace request data', function(f) {
                Sys.println(f.getData('requestId')
                    + ' : ' + f.getData('assetId')
                    + ' : ' + f.getData('connectionId')
                    + ' : ' + f.getData('productId')
                    + ' : ' + f.getData('status'));
            });
            /*
            .step('Approve request', function(f) {
                f.getRequest().approveByTemplate('TL-000-000-000');
                f.getRequest().approveByTile('Markdown text');
            })
            */

        // Process requests
        new Processor()
            .flow(flow)
            .processRequests(new Query()
                .equal('asset.product.id__in', Env.getConfig().getProductsString())
                .equal('status', 'pending'));

        // Trace total time
        var finalTime = Date.now().getTime();
        Sys.println('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
