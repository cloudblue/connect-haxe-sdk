/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/

import connect.util.Collection;
import connect.Env;
import connect.Flow;
import connect.Processor;
import connect.api.Query;
import connect.logger.LoggerConfig;


class Example {
    public static function main() {
        // Get initial time
        final initialTime = Date.now().getTime();

        Env.loadConfig('examples/config.json');
        Env.initLogger(new LoggerConfig().path('examples/log'));

        // Define main flow
        final flow = new Flow(null)
            .step('Add dummy data', function(f: Flow): Void {
                f.setData('requestId', f.getAssetRequest().id)
                    .setData('assetId', f.getAssetRequest().asset.id)
                    .setData('connectionId', f.getAssetRequest().asset.connection.id)
                    .setData('productId', f.getAssetRequest().asset.product.id)
                    .setData('status', f.getAssetRequest().status);
            })
            .step('Trace request data', function(f: Flow): Void {
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
            .processAssetRequests(new Query()
                .equal('asset.product.id__in', Env.getConfig().getProductsString())
                .equal('status', 'pending'));

        // Trace total time
        final finalTime = Date.now().getTime();
        Sys.println('Total time: ' + ((finalTime - initialTime) / 1000) + ' secs.');
    }
}
