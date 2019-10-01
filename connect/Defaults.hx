package connect;


class Defaults {
    /**
        Initializes the configuration singleton.

        @param apiUrl Value for the apiUrl property.
        @param apiKey Value for the apiKey property.
        @param products Collection of product ids that can be processed with this configuration.
        @throws String if the configuration is already initialized.
    **/
    public static function initConfig(apiUrl: String, apiKey: String,
            products: Collection<String>): Void {
        if (config == null) {
            config = new Config(apiUrl, apiKey, products);
        } else {
            throw "Config instance is already initialized.";
        }
    }
    

    /**
        Initializes the configuration singleton using a JSON file.

        @param filename Name of the configuration JSON file to parse.
        @throws Exception if the file cannot be parsed.
        @throws String if the configuration is already initialized.
    **/
    public static function loadConfig(filename: String): Void {
        if (config == null) {
            var content = sys.io.File.getContent(filename);
            var object = haxe.Json.parse(content);
            config = new Config(object.apiEndpoint, object.apiKey, new Collection<String>([object.products]));
        } else {
            throw "Config instance is already initialized.";
        }
    }


    /**
        Returns the config instance. If it is not initialized, it tries to initialize it from
        the file "config.json".

        @returns the default instance.
        @throws Exception if the instance is not initialized and the file "config.json" cannot be
            parsed.
    **/
    public static function getConfig() {
        if (config == null) {
            loadConfig("config.json");
        }
        return config;
    }



    public static function getApiClient() : connect.api.IApiClient {
        if (apiClient == null) {
            apiClient = new connect.api.impl.ApiClientImpl();
        }
        return apiClient;
    }


    public static function getFulfillmentApi() : connect.api.IFulfillmentApi {
        if (fulfillmentApi == null) {
            fulfillmentApi = new connect.api.impl.FulfillmentApiImpl();
        }
        return fulfillmentApi;
    }


    public static function getUsageApi() : connect.api.IUsageApi {
        if (usageApi == null) {
            usageApi = new connect.api.impl.UsageApiImpl();
        }
        return usageApi;
    }


    public static function getTierApi() : connect.api.ITierApi {
        if (tierApi == null) {
            tierApi = new connect.api.impl.TierApiImpl();
        }
        return tierApi;
    }


    public static function getGeneralApi() : connect.api.IGeneralApi {
        if (generalApi == null) {
            generalApi = new connect.api.impl.GeneralApiImpl();
        }
        return generalApi;
    }


    private static var config: Config;
    private static var apiClient: connect.api.IApiClient;
    private static var fulfillmentApi: connect.api.IFulfillmentApi;
    private static var usageApi: connect.api.IUsageApi;
    private static var tierApi: connect.api.ITierApi;
    private static var generalApi: connect.api.IGeneralApi;
}
