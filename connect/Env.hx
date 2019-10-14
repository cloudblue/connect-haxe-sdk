package connect;

import connect.api.IApiClient;
import connect.api.IFulfillmentApi;
import connect.api.IUsageApi;
import connect.api.ITierApi;
import connect.api.IGeneralApi;

// Need to make sure that these get compiled
import connect.api.impl.ApiClientImpl;
import connect.api.impl.FulfillmentApiImpl;
import connect.api.impl.UsageApiImpl;
import connect.api.impl.TierApiImpl;
import connect.api.impl.GeneralApiImpl;


/**
    In order to be able to perform their tasks, many classes in the SDK rely on the global
    availability of several objects. For example, the URL and credentials used to communicate
    with the platform are defined in an instance of the `connect.Config` class, while the
    ability to perform Http requests is performed by an instance of a class that implements
    the `connect.api.IApiClient` interface.

    Since these dependencies must be globally available, the `Env` class contains static
    method to obtain the default instances of these clases from anywhere. To minimize the
    side-effects that can be caused by changes in the values of global objects in a program,
    all environment objects are immutable, providing a side-effect free context for the program
    to run.

    All objects returned here are lazy-initialized, meaning that they are not created until they
    are requested. In order to provide the connector configuration, a call to
    `Env.initConfig` or `Env.loadConfig` can be provided at the top of the program.
    Otherwise, the configuration will be automatically loaded from the "config.json" file.

    Many of the objects returned by this class are defined in a public interface, with a default
    implementation provided by the environment. This is because when unit testing, these classes
    get replaced through dependency injection by mocked ones, allowing to a sandboxed unit testing
    environment.
**/
class Env {
    /**
        Initializes the configuration object. It must have not been previously configured.

        @param apiUrl Value for the apiUrl property.
        @param apiKey Value for the apiKey property.
        @param products Collection of product ids that can be processed with this configuration.
        @throws String If the configuration is already initialized.
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
        Initializes the configuration object using a JSON file.  It must have not been previously
        configured.

        @param filename Name of the configuration JSON file to parse.
        @throws Exception If the file cannot be parsed.
        @throws String If the configuration is already initialized.
    **/
    public static function loadConfig(filename: String): Void {
        if (config == null) {
            var content = sys.io.File.getContent(filename);
            var object = haxe.Json.parse(content);
            config = new Config(object.apiEndpoint, object.apiKey,
                Collection._fromArray([object.products]));
        } else {
            throw "Config instance is already initialized.";
        }
    }


    /**
        @returns `true` is config has already been initialized, `false` otherwise.
    **/
    public static function isConfigInitialized(): Bool {
        return config != null;
    }


    /**
        Returns the configuration object. If it is not initialized, it tries to initialize it from
        the file "config.json".

        @returns The default instance.
        @throws Exception If the instance is not initialized and the file "config.json" cannot be
            parsed.
    **/
    public static function getConfig() {
        if (config == null) {
            loadConfig("config.json");
        }
        return config;
    }


    /**
        @returns The API Client, used to make all low level Http requests to the platform.
        @throws String If a class implementing the IApiClient interface cannot be instanced.
    **/
    public static function getApiClient() : IApiClient {
        if (apiClient == null) {
            apiClient = createInstance('IApiClient');
        }
        return apiClient;
    }


    /**
        @returns The Fulfillment API instance, used to make all fulfillment requests to the
            platform.
        @throws String If a class implementing the IFulfillmentApi interface cannot be instanced.
    **/
    public static function getFulfillmentApi() : IFulfillmentApi {
        if (fulfillmentApi == null) {
            fulfillmentApi = createInstance('IFulfillmentApi');
        }
        return fulfillmentApi;
    }


    /**
        @returns The Usage API instance, used to make all usage requests to the platform.
        @throws String If a class implementing the IUsageApi interface cannot be instanced.
    **/
    public static function getUsageApi() : IUsageApi {
        if (usageApi == null) {
            usageApi = createInstance('IUsageApi');
        }
        return usageApi;
    }


    /**
        @returns The Tier API instance, used to make all tier requests to the platform.
        @throws String If a class implementing the ITierApi interface cannot be instanced.
    **/
    public static function getTierApi() : ITierApi {
        if (tierApi == null) {
            tierApi = createInstance('ITierApi');
        }
        return tierApi;
    }


    /**
        @returns The General API instance, used to make all general requests to the platform.
        @throws String If a class implementing the IGeneralApi interface cannot be instanced.
    **/
    public static function getGeneralApi() : IGeneralApi {
        if (generalApi == null) {
            generalApi = createInstance('IGeneralApi');
        }
        return generalApi;
    }


    @:dox(hide)
    public static function _reset(?deps: Dictionary) {
        config = null;
        apiClient = null;
        fulfillmentApi = null;
        usageApi = null;
        tierApi = null;
        generalApi = null;
        dependencies = null;
        init(deps);
    }


    private static var config: Config;
    private static var apiClient: IApiClient;
    private static var fulfillmentApi: IFulfillmentApi;
    private static var usageApi: IUsageApi;
    private static var tierApi: ITierApi;
    private static var generalApi: IGeneralApi;
    private static var defaultDependencies : Dictionary;
    private static var dependencies: Dictionary;


    private static function init(?deps: Dictionary): Void {
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
