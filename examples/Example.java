import connect.Env;
import connect.Flow;
import connect.Logger;
import connect.Processor;
import connect.api.Query;
import connect.models.IdModel;


public class Example {
    public static void main(String[] args) {
        //Env.initLogger("log.md", Logger.LEVEL_DEBUG, null, null);
        
        // Define main flow
        Flow flow = new Flow((IdModel m) -> true)
            .step("Add dummy data", (Flow f) -> {
                f.setData("requestId", f.getAssetRequest().id)
                    .setData("assetId", f.getAssetRequest().asset.id)
                    .setData("connectionId", f.getAssetRequest().asset.connection.id)
                    .setData("productId", f.getAssetRequest().asset.product.id)
                    .setData("status", f.getAssetRequest().status);
            })
            .step("Trace request data", (Flow f) -> {
                System.out.println(f.getData("requestId")
                    + " : " + f.getData("assetId")
                    + " : " + f.getData("connectionId")
                    + " : " + f.getData("productId")
                    + " : " + f.getData("status"));
            });
            /*
            .step("Approve request", (Processor p) -> {
                p.getAssetRequest().approveByTemplate("TL-000-000-000");
                p.getAssetRequest().approveByTile("Markdown text");
            })
            */
        
        // Process requests
        new Processor()
            .flow(flow)
            .processRequests(new Query()
                .equal("asset.product.id__in", Env.getConfig().getProductsString())
                .equal("status", "pending"));
    }
}
