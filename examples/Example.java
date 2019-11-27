import connect.Env;
import connect.Flow;
import connect.Logger;
import connect.Processor;
import connect.api.Query;
import connect.models.IdModel;
import connect.models.Request;


public class Example {
    public static void main(String[] args) {
        //Env.initLogger("log.md", Logger.LEVEL_DEBUG, null);
        
        // Define main flow
        Flow flow = new Flow((IdModel m) -> true)
            .step("Add dummy data", (Flow f) -> {
                f.setData("requestId", f.getRequest().id)
                    .setData("assetId", f.getRequest().asset.id)
                    .setData("connectionId", f.getRequest().asset.connection.id)
                    .setData("productId", f.getRequest().asset.product.id)
                    .setData("status", f.getRequest().status);
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
                p.getRequest().approveByTemplate("TL-000-000-000");
                p.getRequest().approveByTile("Markdown text");
            })
            */
        
        // Process requests
        new Processor()
            .flow(flow)
            .processRequests(new Query()
                .set("asset.product.id__in", Env.getConfig().getProductsString())
                .set("status", "pending"));
    }
}
