import connect.Env;
import connect.Logger;
import connect.Processor;
import connect.api.QueryParams;
import connect.models.Request;


public class Example {
    public static void main(String[] args) {
        //Env.initLogger("log.md", Logger.LEVEL_DEBUG, null);
        
        new Processor()
            .step("Add dummy data", (Processor p, String input) -> {
                p.setData("assetId", p.getRequest().asset.id)
                    .setData("connectionId", p.getRequest().asset.connection.id)
                    .setData("productId", p.getRequest().asset.product.id)
                    .setData("status", p.getRequest().status);
                return p.getRequest().id;
            })
            .step("Trace request data", (Processor p, String requestId) -> {
                System.out.println(requestId
                    + " : " + p.getData("assetId")
                    + " : " + p.getData("connectionId")
                    + " : " + p.getData("productId")
                    + " : " + p.getData("status"));
                return "";
            })
            /*
            .step("Approve request", (Processor p, String input) -> {
                p.getRequest().approveByTemplate("TL-000-000-000");
                p.getRequest().approveByTile("Markdown text");
                return "";
            })
            */
            .run(Request.class, new QueryParams()
                .set("asset.product.id__in", Env.getConfig().getProductsString())
                .set("status", "pending"));
    }
}
