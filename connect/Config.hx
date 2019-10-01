package connect;

/**
    Configuration singleton that allows communication with the Connect platform.
**/
class Config {
    public function new(apiUrl: String, apiKey: String, products: Collection<String>) {
        this.apiUrl = (apiUrl.charAt(apiUrl.length - 1) == "/") ? apiUrl : apiUrl + "/";
        this.apiKey = (apiKey.indexOf("ApiKey ") == 0) ? apiKey : ("ApiKey " + apiKey);
        this.products = products.copy();
    }


    /**
        @returns Endpoint to interact with Connect API.
    **/
    public function getApiUrl(): String {
        return this.apiUrl;
    }


    /**
        @returns Authorization key.
    **/
    public function getApiKey(): String {
        return this.apiKey;
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
    
    
    private var apiUrl: String;
    private var apiKey: String;
    private var products: Collection<String>;
}
