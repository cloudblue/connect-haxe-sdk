using System;
using connect;
using connect.api;
using connect.util;

namespace Example
{
    class Example
    {
        public static void Main(string[] args)
        {
            // Define main flow
            var flow = new Flow((_) => true)
                .step("Add dummy data", (f) => {
                    f.setData("requestId", f.getAssetRequest().id)
                        .setData("assetId", f.getAssetRequest().asset.id)
                        .setData("connectionId", f.getAssetRequest().asset.connection.id)
                        .setData("productId", f.getAssetRequest().asset.product.id)
                        .setData("status", f.getAssetRequest().status);
                })
                .step("Trace request data", (f) => {
                    Console.WriteLine(f.getData("requestId")
                        + " : " + f.getData("assetId")
                        + " : " + f.getData("connectionId")
                        + " : " + f.getData("productId")
                        + " : " + f.getData("status"));
                });
                /*
                .step("Approve request", (Flow f) => {
                    f.getAssetRequest().approveByTemplate("TL-000-000-000");
                    f.getAssetRequest().approveByTile("Markdown text");
                });
                */

            // Process requests
            new Processor()
                .flow(flow)
                .processAssetRequests(new Query()
                    .equal("asset.product.id__in", Env.getConfig().getProductsString())
                    .equal("status", "pending"));
        }
    }
}
