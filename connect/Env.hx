/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;

import connect.logger.ILoggerFormatter;
import connect.logger.LoggerHandler;
import connect.api.IApiClient;
import connect.api.FulfillmentApi;
import connect.api.GeneralApi;
import connect.api.impl.ApiClientImpl;
import connect.api.MarketplaceApi;
import connect.api.SubscriptionsApi;
import connect.api.TierApi;
import connect.api.UsageApi;
import connect.api.Query;
import connect.logger.Logger;
import connect.logger.LoggerConfig;
import connect.util.Collection;
import connect.util.Dictionary;
import connect.models.IdModel;

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
    private static var config: Config;
    private static var loggers: Dictionary = new Dictionary();
    private static var defaultQuery: Query;
    private static var apiClient: IApiClient;
    private static var fulfillmentApi: FulfillmentApi;
    private static var usageApi: UsageApi;
    private static var tierApi: TierApi;
    private static var generalApi: GeneralApi;
    private static var marketplaceApi: MarketplaceApi;
    private static var subscriptionsApi: SubscriptionsApi;

    private static inline var ROOT_LOGGER: String = "root";

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
            final products: Collection<String> =
                Std.is(configProducts, Collection) ? configProducts :
                Std.is(configProducts, String) ? Collection._fromArray([configProducts]) :
                null;
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
        if(!loggers.exists(ROOT_LOGGER)){
            loggers.set(ROOT_LOGGER,new Logger(config));
        } else {
            throw "Logger instance is already initialized.";
        }
    }


    /**
        Get logger for given request, if it doesnt exists it will be created and context specified.
     **/
    public static function getLoggerForRequest(request: Null<IdModel>): Logger {
        if(request != null && Reflect.field(request,"id") != null) {
            if(!loggers.exists(request.id)) {
                final originalConfig:LoggerConfig = loggers.get(ROOT_LOGGER).getInitialConfig();
                final requestLogger = new Logger(copyLoggerConfig(originalConfig));
                for (handler in requestLogger.getHandlers()) {
                        handler.formatter.setRequest(request.id);
                }
                requestLogger.setFilenameForRequest(request);
                loggers.set(request.id,requestLogger);
            }
            return loggers.get(request.id);
        }

        if (!loggers.exists(ROOT_LOGGER)) {
            final requestLogger = new Logger(null);
            loggers.set(ROOT_LOGGER,requestLogger);
        }

        return loggers.get(ROOT_LOGGER);
    }

    /**
        @returns cloned LoggerConfig object
    **/
    private static function copyLoggerConfig(initialConfig: LoggerConfig): LoggerConfig {
        final newConfig: LoggerConfig = new LoggerConfig();
        newConfig.path(initialConfig.path_);
        newConfig.level(initialConfig.level_);
        newConfig.maskedFields(initialConfig.maskedFields_);
        newConfig.maskedParams(initialConfig.maskedParams_);
        newConfig.beautify(initialConfig.beautify_);
        newConfig.compact(initialConfig.compact_);
        newConfig.regexMaskingList_ = initialConfig.regexMaskingList_;
        final newHandlers = new Collection<LoggerHandler>();
        for(handler in  initialConfig.handlers_){
            final newHandler = new LoggerHandler(handler.formatter.copy(),handler.writer.copy());
            newHandlers.push(newHandler);
        }
        newConfig.handlers(newHandlers);
        return newConfig;
    }


    /**
        @returns `true` if logger has already been initialized, `false` otherwise.
    **/
    public static function isLoggerInitialized(): Bool {
        return loggers.exists(ROOT_LOGGER);
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
        `Info` with the path "logs".

        @returns The environment logger.
    **/
    public static function getLogger(): Logger {
        if (!isLoggerInitialized()) {
            initLogger(null);
        }
        return loggers.get(ROOT_LOGGER);
    }

    /**
        @returns The API Client, used to make all low level Http requests to the platform.
        @throws String If a class implementing the IApiClient interface cannot be instanced.
    **/
    public static function getApiClient(): IApiClient {
        if (apiClient == null) {
            apiClient = new ApiClientImpl();
        }
        return apiClient;
    }

    @:dox(hide)
    public static function getFulfillmentApi(): FulfillmentApi {
        if (fulfillmentApi == null) {
            fulfillmentApi = new FulfillmentApi();
        }
        return fulfillmentApi;
    }

    @:dox(hide)
    public static function getUsageApi(): UsageApi {
        if (usageApi == null) {
            usageApi = new UsageApi();
        }
        return usageApi;
    }

    @:dox(hide)
    public static function getTierApi(): TierApi {
        if (tierApi == null) {
            tierApi = new TierApi();
        }
        return tierApi;
    }

    @:dox(hide)
    public static function getGeneralApi(): GeneralApi {
        if (generalApi == null) {
            generalApi = new GeneralApi();
        }
        return generalApi;
    }

    @:dox(hide)
    public static function getSubscriptionsApi(): SubscriptionsApi {
        if (subscriptionsApi == null) {
            subscriptionsApi = new SubscriptionsApi();
        }
        return subscriptionsApi;
    }

    @:dox(hide)
    public static function getMarketplaceApi(): MarketplaceApi {
        if (marketplaceApi == null) {
            marketplaceApi = new MarketplaceApi();
        }
        return marketplaceApi;
    }

    @:dox(hide)
    public static function _reset(?client: IApiClient = null) {
        config = null;
        loggers = new Dictionary();
        defaultQuery = null;
        apiClient = client;
        fulfillmentApi = null;
        usageApi = null;
        tierApi = null;
        generalApi = null;
        marketplaceApi = null;
        subscriptionsApi = null;
    }

    @:dox(hide)
    public static function _getDefaultQuery(): Query {
        return defaultQuery;
    }
}
