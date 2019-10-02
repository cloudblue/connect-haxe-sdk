package connect;

import connect.api.IApiClient;
import connect.api.IFulfillmentApi;
import connect.api.IUsageApi;
import connect.api.ITierApi;
import connect.api.IGeneralApi;

// Need to make sure that there are compiled
import connect.api.impl.ApiClientImpl;
import connect.api.impl.FulfillmentApiImpl;
import connect.api.impl.UsageApiImpl;
import connect.api.impl.TierApiImpl;
import connect.api.impl.GeneralApiImpl;


class Environment {
    public static function init(?deps: Dictionary): Void {
        initDefaultDependencies();
        if (dependencies == null) {
            dependencies = new Dictionary();
            if (deps != null) {
                var keys = deps.keys();
                for (key in keys) {
                    if (defaultDependencies.exists(key)) {
                        dependencies.setString(key, deps.getString(key));
                    }
                }
            }
        }
    }


    public static function load(filename: String): Void {
        initDefaultDependencies();
        if (dependencies == null) {
            var content = sys.io.File.getContent(filename);
            init(Util.toDictionary(haxe.Json.parse(content)));
        }
    }


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


    public static function getApiClient() : IApiClient {
        if (apiClient == null) {
            apiClient = createInstance('IApiClient');
        }
        return apiClient;
    }


    public static function getFulfillmentApi() : IFulfillmentApi {
        if (fulfillmentApi == null) {
            fulfillmentApi = createInstance('IFulfillmentApi');
        }
        return fulfillmentApi;
    }


    public static function getUsageApi() : IUsageApi {
        if (usageApi == null) {
            usageApi = createInstance('IUsageApi');
        }
        return usageApi;
    }


    public static function getTierApi() : ITierApi {
        if (tierApi == null) {
            tierApi = createInstance('ITierApi');
        }
        return tierApi;
    }


    public static function getGeneralApi() : IGeneralApi {
        if (generalApi == null) {
            generalApi = createInstance('IGeneralApi');
        }
        return generalApi;
    }


    // These methods should be used only in unit testing


    public static function _reset() {
        config = null;
        apiClient = null;
        fulfillmentApi = null;
        usageApi = null;
        tierApi = null;
        generalApi = null;
        dependencies = null;
    }


    private static var config: Config;
    private static var apiClient: IApiClient;
    private static var fulfillmentApi: IFulfillmentApi;
    private static var usageApi: IUsageApi;
    private static var tierApi: ITierApi;
    private static var generalApi: IGeneralApi;
    private static var defaultDependencies : Dictionary;
    private static var dependencies: Dictionary;


    private static function initDefaultDependencies(): Void {
        if (defaultDependencies == null) {
            defaultDependencies = new Dictionary()
                .setString('IApiClient', 'connect.api.impl.ApiClientImpl')
                .setString('IFulfillmentApi', 'connect.api.impl.FulfillmentApiImpl')
                .setString('IUsageApi', 'connect.api.impl.UsageApiImpl')
                .setString('ITierApi', 'connect.api.impl.TierApiImpl')
                .setString('IGeneralApi', 'connect.api.impl.GeneralApiImpl');
        }
    }


    private static function createInstance(interfaceName: String): Dynamic {
        init();
        var className = (dependencies.exists(interfaceName))
            ? dependencies.getString(interfaceName)
            : defaultDependencies.getString(interfaceName);
        var classObj = Type.resolveClass(className);
        if (classObj != null) {
            return Type.createInstance(classObj, []);
        } else {
            throw 'Cannot find class name "${className}"';
        }
    }
}
