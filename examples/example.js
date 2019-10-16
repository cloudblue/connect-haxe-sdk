const connect = require("../_build/_packages/js/connect");
const Env = connect.Env;
const Logger = connect.Logger;
const Processor = connect.Processor;
const QueryParams = connect.api.QueryParams;
const Request = connect.models.Request;

//Env.initLogger("log.md", Logger.LEVEL_ERROR, null);

// Process requests
new Processor()
    .step("Add dummy data", function(p, _) {
        p.setData("assetId", p.getRequest().asset.id)
            .setData("connectionId", p.getRequest().asset.connection.id)
            .setData("productId", p.getRequest().asset.product.id)
            .setData("status", p.getRequest().status);
        return p.getRequest().id;
    })
    .step("Trace request data", function(p, requestId) {
        console.log(requestId
            + " : " + p.getData("assetId")
            + " : " + p.getData("connectionId")
            + " : " + p.getData("productId")
            + " : " + p.getData("status"));
    })
    /*
    .step("Approve request", function(p, _) {
        p.getRequest().approveByTemplate("TL-000-000-000");
        p.getRequest().approveByTile("Markdown text");
    })
    */
    .run(Request, new QueryParams()
        .set("asset.product.id__in", Env.getConfig().getProductsString())
        .set("status", "pending"));
