import connect.Env;
import connect.Flow;
import connect.Logger;
import connect.Processor;
import connect.api.QueryParams;
import connect.models.IdModel;
import connect.models.Request;


public class Example {
    public static void main(String[] args) {
        //Env.initLogger("log.md", Logger.LEVEL_DEBUG, null);
        
        // Define main flow
        Flow flow = new Flow((IdModel m) -> true)
            .step("Add dummy data", (Flow f, String input) -> {
                f.setData("assetId", f.getRequest().asset.id)
                    .setData("connectionId", f.getRequest().asset.connection.id)
                    .setData("productId", f.getRequest().asset.product.id)
                    .setData("status", f.getRequest().status);
                return f.getRequest().id;
            })
            .step("Trace request data", (Flow f, String requestId) -> {
                System.out.println(requestId
                    + " : " + f.getData("assetId")
                    + " : " + f.getData("connectionId")
                    + " : " + f.getData("productId")
                    + " : " + f.getData("status"));
                return "";
            });
            /*
            .step("Approve request", (Processor p, String input) -> {
                p.getRequest().approveByTemplate("TL-000-000-000");
                p.getRequest().approveByTile("Markdown text");
                return "";
            })
            */
        
        // Process requests
        new Processor()
            .flow(flow)
            .processRequests(new QueryParams()
                .set("asset.product.id__in", Env.getConfig().getProductsString())
                .set("status", "pending"));
    }
}
