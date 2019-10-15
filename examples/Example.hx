import connect.Env;
import connect.Logger;
import connect.Processor;
import connect.api.QueryParams;
import connect.models.Request;

class Example {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        Env.loadConfig('examples/config.json');
        Env.initLogger('examples/log.md', Logger.LEVEL_DEBUG, null);

        // Process requests
        new Processor()
            .step('Add dummy data', function(p, input) {
                p.setData('assetId', p.getRequest().asset.id)
                    .setData('connectionId', p.getRequest().asset.connection.id)
                    .setData('productId', p.getRequest().asset.product.id)
                    .setData('status', p.getRequest().status);
                return p.getRequest().id;
            })
            .step('Trace request data', function(p, requestId) {
                Sys.println(requestId
                    + ' : ' + p.getData('assetId')
                    + ' : ' + p.getData('connectionId')
                    + ' : ' + p.getData('productId')
                    + ' : ' + p.getData('status'));
                return '';
            })
            /*
            .step('Approve request', function(p, input) {
                p.getRequest().approveByTemplate('TL-000-000-000');
                p.getRequest().approveByTile('Markdown text');
                return '';
            })
            */
            .run(Request, new QueryParams()
                .set('asset.product.id__in', Env.getConfig().getProductsString())
                .set('status', 'pending'));

        // Trace total time
        var finalTime = Date.now().getTime();
        Sys.println('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
