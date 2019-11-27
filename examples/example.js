const connect = require("../_packages/connect.js/connect");
const Env = connect.Env;
const Flow = connect.Flow;
const Logger = connect.Logger;
const Processor = connect.Processor;
const Query = connect.api.Query;
const Request = connect.models.Request;

//Env.initLogger("log.md", Logger.LEVEL_ERROR, null);

// Define main flow
const flow = new Flow(null)
    .step("Add dummy data", function(p) {
        p.setData("requestId", p.getRequest().id)
            .setData("assetId", p.getRequest().asset.id)
            .setData("connectionId", p.getRequest().asset.connection.id)
            .setData("productId", p.getRequest().asset.product.id)
            .setData("status", p.getRequest().status);
    })
    .step("Trace request data", function(p) {
        console.log(p.getData("requestId")
            + " : " + p.getData("assetId")
            + " : " + p.getData("connectionId")
            + " : " + p.getData("productId")
            + " : " + p.getData("status"));
    });
    /*
    .step("Approve request", function(p) {
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
