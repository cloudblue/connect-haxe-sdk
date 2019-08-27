package connect;


/**
    A Factory to create Processor instances for the different Connect APIs.
**/
class ProcessorFactory {
    /**
        Creates a Processor for the Fulfillment API. The function assigned to onProcessRequest
        should return an and implementing the Activation interface to approve the request. There
        are two classes that implement the interface:

        - TemplateActivation: Approves the request based on a tile template.
        - TileActivation: Approves the request providing a text in Markdown format for the tile.

        The tile will be shwon on the product page on Connect. In other cases, you must throw one
        of these exceptions:

        - InquireRequest: Inquire for more information.
        - FailRequest: Causes the request to fail.
        - SkipRequest: Skips processing the request.

        @param onProcessRequest Function to assign to the onProcessRequest dynamic method.
        @returns the created Processor.
    **/
    public static function newFulfillmentProcessor(onProcessRequest:(Dynamic) -> Activation) : Processor {
        return new Processor(
            "requests",
            [
                "status" => "pending",
                "limit" => "1000",
                "asset.product.id__in" => Config.getInstance().getProductsString()
            ],
            onProcessRequest
        );
    }
}
