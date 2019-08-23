package connect;

class ProcessorFactory {
    public static function newFulfillmentProcessor() : Processor {
        return new Processor(
            "requests",
            [
                "status" => "pending",
                "limit" => "1000",
                "asset.product.id__in" => Config.getInstance().getProductsString()
            ]
        );
    }
}
