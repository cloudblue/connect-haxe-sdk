import connect.Env;
import connect.api.QueryParams;
import connect.models.*;

class Example {
    public static function main() {
        // Get initial time
        var initialTime = Date.now().getTime();

        // List requests
        var requests = Request.list(new QueryParams()
            .set('asset.product.id__in', Env.getConfig().getProductsString())
            .set('status', 'pending')
        );

        // Process requests
        for (request in requests) {
            trace(request.id
                + ' : ' + request.asset.id
                + ' : ' + request.asset.connection.id
                + ' : ' + request.asset.product.id
                + ' : ' + request.status);

            /*
            // Approve by template or tile
            request.approveByTemplate('TL-000-000-000');
            request.approveByTile('Markdown text');
            */
        }

        // Trace total time
        var finalTime = Date.now().getTime();
        trace('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
