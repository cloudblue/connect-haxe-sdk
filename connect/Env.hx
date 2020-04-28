/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;

import connect.api.IApiClient;
import connect.api.IFulfillmentApi;
import connect.api.IGeneralApi;
import connect.api.IMarketplaceApi;
import connect.api.ITierApi;
import connect.api.IUsageApi;
import connect.api.Query;
import connect.logger.Logger;
import connect.logger.LoggerConfig;
import connect.util.Collection;
import connect.util.Dictionary;

// Need to make sure that these get compiled
import connect.api.impl.ApiClientImpl;
import connect.api.impl.FulfillmentApiImpl;
import connect.api.impl.GeneralApiImpl;
import connect.api.impl.MarketplaceApiImpl;
import connect.api.impl.TierApiImpl;
import connect.api.impl.UsageApiImpl;


/**
    In order to be able to perform their tasks, many classes in the SDK rely on the global
    availability of several objects. For example, the URL and credentials used to communicate
    with the platform are defined in an instance of the `connect.Config` class, while the
    ability to perform Http requests is performed by an instance of a class that implements
    the `connect.api.IApiClient` interface.

    Since these dependencies must be globally available, the `Env` class contains static
    methods to obtain the default instances of these classes from anywhere. To minimize the
    side-effects that can be caused by changes in the values of global objects in a program,
    all environment objects are immutable, providing a side-effect free context for the program
    to run.

    All objects returned here are lazy-initialized, meaning that they are not created until they
    are requested. In order to provide the connector configuration, a call to
    `Env.initConfig` or `Env.loadConfig` can be provided at the top of the program.
    Otherwise, the configuration will be automatically loaded from the "config.json" file.

    Likewise, the `Logger` can be initialized with a call to `Env.initLogger`, assuming it has not
    been done yet.

    Many of the objects returned by this class are defined in a public interface, with a default
    implementation provided by the environment. This is because when unit testing, these classes
    get replaced through dependency injection by mocked ones, allowing to a sandboxed unit testing
    environment.
**/
class Env extends Base {
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
            config = new Config(apiUrl, apiKey, products, null);
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
            final content = sys.io.File.getContent(filename);
            final dict = Dictionary.fromObject(haxe.Json.parse(content));
            final apiUrl = dict.get('apiEndpoint');
            final apiKey = dict.get('apiKey');
            final configProducts: Dynamic = dict.get('products');
            final products: Collection<String> = Std.is(configProducts, Collection)
                ? configProducts
                : Std.is(configProducts, String)
                ? Collection._fromArray([configProducts])
                : null;
            dict.remove('apiEndpoint');
            dict.remove('apiKey');
            dict.remove('products');
            config = new Config(apiUrl, apiKey, products, dict);
        } else {
            throw "Config instance is already initialized.";
        }
    }


    /**
        @returns `true` if config has already been initialized, `false` otherwise.
    **/
    public static function isConfigInitialized(): Bool {
        return config != null;
    }


    /**
        Initializes the logger. It must have not been previously configured.

        @param config The configuration of the logger.
    **/
    public static function initLogger(config: LoggerConfig): Void {
        if (logger == null) {
            logger = new Logger(config);
        } else {
            throw "Logger instance is already initialized.";
        }
    }


    /**
        @returns `true` if logger has already been initialized, `false` otherwise.
    **/
    public static function isLoggerInitialized(): Bool {
        return logger != null;
    }


    /**
     * Initializes the default `Query`. This query can contain common filters and be easily
     * embedded in any other query by using the `Query.default` method.
     * @param query The default `Query`.
     */
    public static function initDefaultQuery(query: Query): Void {
        if (defaultQuery == null) {
            defaultQuery = query.copy();
        } else {
            throw 'Default Query instance in already initialized.';
        }
    }


    /**
     * @returns `true` if default query has already been set, `false` otherwise;
     */
    public static function isDefaultQueryInitialized(): Bool {
        return defaultQuery != null;
    }


    /**
        Returns the configuration object. If it is not initialized, it tries to initialize it from
        the file "config.json".

        @returns The environment config.
        @throws Exception If the instance is not initialized and the file "config.json" cannot be
            parsed.
    **/
    public static function getConfig(): Config {
        if (!isConfigInitialized()) {
            loadConfig("config.json");
        }
        return config;
    }


    /**
        Returns the logger object. If it is not initialized, it will initialize it in the level
        `Info` with a filename of "log.md".

        @returns The environment logger.
    **/
    public static function getLogger(): Logger {
        if (!isLoggerInitialized()) {
            initLogger(null);
        }
        return logger;
    }


    /**
        @returns The API Client, used to make all low level Http requests to the platform.
        @throws String If a class implementing the IApiClient interface cannot be instanced.
    **/
    public static function getApiClient(): IApiClient {
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
    @:dox(hide)
    public static function getFulfillmentApi(): IFulfillmentApi {
        if (fulfillmentApi == null) {
            fulfillmentApi = createInstance('IFulfillmentApi');
        }
        return fulfillmentApi;
    }


    /**
        @returns The Usage API instance, used to make all usage requests to the platform.
        @throws String If a class implementing the IUsageApi interface cannot be instanced.
    **/
    @:dox(hide)
    public static function getUsageApi(): IUsageApi {
        if (usageApi == null) {
            usageApi = createInstance('IUsageApi');
        }
        return usageApi;
    }


    /**
        @returns The Tier API instance, used to make all tier requests to the platform.
        @throws String If a class implementing the ITierApi interface cannot be instanced.
    **/
    @:dox(hide)
    public static function getTierApi(): ITierApi {
        if (tierApi == null) {
            tierApi = createInstance('ITierApi');
        }
        return tierApi;
    }


    /**
        @returns The General API instance, used to make all general requests to the platform.
        @throws String If a class implementing the IGeneralApi interface cannot be instanced.
    **/
    @:dox(hide)
    public static function getGeneralApi(): IGeneralApi {
        if (generalApi == null) {
            generalApi = createInstance('IGeneralApi');
        }
        return generalApi;
    }


    @:dox(hide)
    public static function getMarketplaceApi(): IMarketplaceApi {
        if (marketplaceApi == null) {
            marketplaceApi = createInstance('IMarketplaceApi');
        }
        return marketplaceApi;
    }


    @:dox(hide)
    public static function _reset(?deps: Dictionary) {
        config = null;
        logger = null;
        defaultQuery = null;
        apiClient = null;
        fulfillmentApi = null;
        usageApi = null;
        tierApi = null;
        generalApi = null;
        marketplaceApi = null;
        dependencies = null;
        init(deps);
    }


    @:dox(hide)
    public static function _getDefaultQuery(): Query {
        return defaultQuery;
    }


    private static var config: Config;
    private static var logger: Logger;
    private static var defaultQuery: Query;
    private static var apiClient: IApiClient;
    private static var fulfillmentApi: IFulfillmentApi;
    private static var usageApi: IUsageApi;
    private static var tierApi: ITierApi;
    private static var generalApi: IGeneralApi;
    private static var marketplaceApi: IMarketplaceApi;
    private static var defaultDependencies : Dictionary;
    private static var dependencies: Dictionary;


    private static function init(?deps: Dictionary): Void {
        initDefaultDependencies();
        if (dependencies == null) {
            dependencies = new Dictionary();
            if (deps != null) {
                final keys = deps.keys();
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
                .setString('IGeneralApi', 'connect.api.impl.GeneralApiImpl')
                .setString('IMarketplaceApi', 'connect.api.impl.MarketplaceApiImpl');
        }
    }


    private static function createInstance(interfaceName: String): Dynamic {
        init();
        final className = (dependencies.exists(interfaceName))
            ? dependencies.getString(interfaceName)
            : defaultDependencies.getString(interfaceName);
        final classObj = Type.resolveClass(className);
        if (classObj != null) {
            return Type.createInstance(classObj, []);
        } else {
            throw 'Cannot find class name "${className}"';
        }
    }
}
