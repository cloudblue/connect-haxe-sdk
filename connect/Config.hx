package connect;

/**
    Configuration singleton that allows communication with the Connect platform.
**/
class Config {
    /** Endpoint to interact with Connect API. **/
    public var apiUrl(default, null): String;

    /** Authorization key. **/
    public var apiKey(default, null): String;


    public function new(apiUrl: String, apiKey: String, products: Collection<String>) {
        this.setApiUrl(apiUrl);
        this.setApiKey(apiKey);
        this.products = products.copy();
    }
    
    
    /**
        Tells whether the configuration is setup to process the specified product.

        @param productId The id of the product.
        @returns true if the configuration is setup to process the specified product.
    **/
    public function hasProduct(productId: String): Bool {
        return products.indexOf(productId) > -1;
    }


    /**
        Get the entire list of products supported by this configuration.

        @returns a comma-separated string with the list of products.
    **/
    public function getProductsString(): String {
        return this.products.join(",");
    }
    
    
    private var products: Collection<String>;

    
    private function setApiUrl(apiUrl: String): Void {
        this.apiUrl = (apiUrl.charAt(apiUrl.length - 1) == "/") ? apiUrl : apiUrl + "/";
    }
    
    
    private function setApiKey(apiKey: String): Void {
        this.apiKey = (apiKey.indexOf("ApiKey ") == 0) ? apiKey : ("ApiKey " + apiKey);
    }
}
