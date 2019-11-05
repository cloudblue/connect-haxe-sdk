package connect;

/**
    This class contains the configuration required for communication with the Connect platform.
**/
class Config extends Base {
    /**
        Creates a new Config object. You don't normally create objects of this class,
        since the SDK uses the default instance provided by `Env.getConfig()`.
    **/
    public function new(apiUrl: String, apiKey: String, products: Collection<String>,
            data: Dictionary) {
        this.apiUrl = (apiUrl.charAt(apiUrl.length - 1) == "/") ? apiUrl : apiUrl + "/";
        this.apiKey = (apiKey.indexOf("ApiKey ") == 0) ? apiKey : ("ApiKey " + apiKey);
        this.products = products.copy();
        this.data = (data != null) ? data : new Dictionary();
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
        @returns `true` if the configuration is setup to process the specified product,
        `false` otherwise.
    **/
    public function hasProduct(productId: String): Bool {
        return products.indexOf(productId) > -1;
    }


    /**
        Get the entire list of products supported by this configuration.

        @returns A string with a comma-separated list of products.
    **/
    public function getProductsString(): String {
        return this.products.join(",");
    }


    /**
        @returns The value of the data with the given key stored in the config. When config
            is loaded from a file, all the additional data found in the file is included
            in the config and can be retrieved with this method.
    **/
    public function getData(key: String): Dynamic {
        return this.data.get(key);
    }
    
    
    private var apiUrl: String;
    private var apiKey: String;
    private var products: Collection<String>;
    private var data: Dictionary;
}
