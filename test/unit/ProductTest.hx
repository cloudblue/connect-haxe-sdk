/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Account;
import connect.models.Action;
import connect.models.Category;
import connect.models.Configurations;
import connect.models.Connection;
import connect.models.CustomerUiSettings;
import connect.models.Document;
import connect.models.DownloadLink;
import connect.models.Hub;
import connect.models.Media;
import connect.models.Model;
import connect.models.Product;
import connect.models.ProductStats;
import connect.models.ProductStatsInfo;
import connect.models.ProductConfigurationParam;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class ProductTest {
    @Before
    public function setup() {
        Env._reset(new ProductApiClientMock());
    }

    @Test
    public function testList() {
        final products = Product.list(null);
        Assert.isType(products, Collection);
        Assert.areEqual(1, products.length());
        Assert.isType(products.get(0), Product);
        Assert.areEqual('PRD-783-317-575', products.get(0).id);
    }

    @Test
    public function testGetOk() {
        final product = Product.get('PRD-783-317-575');
        Assert.isType(product, Product);
        Assert.isType(product.configurations, Configurations);
        Assert.isType(product.customerUiSettings, CustomerUiSettings);
        Assert.isType(product.customerUiSettings.downloadLinks, Collection);
        Assert.areEqual(2, product.customerUiSettings.downloadLinks.length());
        Assert.isType(product.customerUiSettings.downloadLinks.get(0), DownloadLink);
        Assert.isType(product.customerUiSettings.documents, Collection);
        Assert.areEqual(2, product.customerUiSettings.documents.length());
        Assert.isType(product.customerUiSettings.documents.get(0), Document);
        Assert.isType(product.category, Category);
        Assert.isType(product.owner, Account);
        Assert.isType(product.stats, ProductStats);
        Assert.isType(product.stats.agreements, ProductStatsInfo);
        Assert.isType(product.stats.contracts, ProductStatsInfo);
        Assert.areEqual('PRD-783-317-575', product.id);
        Assert.areEqual('Test Product', product.name);
        Assert.areEqual('https://provider.connect.cloud.im/media/dapper-lynxes-35/mj301/media/mj301-logo.png', product.icon);
        Assert.areEqual('', product.shortDescription);
        Assert.areEqual('', product.detailedDescription);
        Assert.areEqual(2, product.version);
        Assert.areEqual(null, product.publishedAt);
        Assert.areEqual(true, product.configurations.suspendResumeSupported);
        Assert.areEqual(true, product.configurations.requiresResellerInformation);
        Assert.areEqual('description', product.customerUiSettings.description);
        Assert.areEqual('short description', product.customerUiSettings.gettingStarted);
        final link = product.customerUiSettings.downloadLinks.get(0);
        Assert.areEqual('Windows', link.title);
        Assert.areEqual('https://fallball.io/download/windows', link.url);
        final document = product.customerUiSettings.documents.get(0);
        Assert.areEqual('Admin Manual', document.title);
        Assert.areEqual('https://fallball.io/manual/admin', document.url);
        Assert.areEqual('CAT-00000', product.category.id);
        Assert.areEqual('Category', product.category.name);
        Assert.areEqual('VA-000-000', product.owner.id);
        Assert.areEqual('Vendor', product.owner.name);
        Assert.areEqual(false, product.latest);
        final stats = product.stats;
        Assert.areEqual(0, stats.listings);
        Assert.areEqual(0, stats.agreements.distribution);
        Assert.areEqual(0, stats.agreements.sourcing);
        Assert.areEqual(0, stats.contracts.distribution);
        Assert.areEqual(0, stats.contracts.sourcing);
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Product.get('PRD-XXX-XXX-XXX'));
    }

    @Test
    public function testListActionsOk() {
        final actions = Product.get('PRD-783-317-575').listActions(null);
        Assert.isType(actions, Collection);
        Assert.areEqual(1, actions.length());
        Assert.isType(actions.get(0), Action);
        Assert.areEqual('sso_action', actions.get(0).id);
    }

    @Test
    public function testListActionsKo() {
        final actions = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listActions(null);
        Assert.isType(actions, Collection);
        Assert.areEqual(0, actions.length());
    }

    @Test
    public function testGetActionOk() {
        final action = Product.get('PRD-783-317-575').getAction('sso_action');
        Assert.isType(action, Action);
        Assert.areEqual('sso_action', action.id);
    }

    @Test
    public function testGetActionKo() {
        final action = Product.get('PRD-783-317-575').getAction('invalid-id');
        Assert.isNull(action);
    }

    @Test
    public function testGetActionKo2() {
        final action = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getAction('sso_action');
        Assert.isNull(action);
    }

    @Test
    public function testGetActionLinkOk() {
        final link = Product.get('PRD-783-317-575').getActionLink('sso_action');
        Assert.areEqual('https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi', link);
    }

    @Test
    public function testGetActionLinkKo() {
        final link = Product.get('PRD-783-317-575').getActionLink('invalid_id');
        Assert.areEqual('', link);
    }

    @Test
    public function testGetConnectionsOk() {
        final connections = Product.get('PRD-783-317-575').getConnections();
        Assert.isType(connections, Collection);
        Assert.areEqual(1, connections.length());
        final connection = connections.get(0);
        Assert.isType(connection, Connection);
        Assert.isType(connection.provider, Account);
        Assert.isType(connection.vendor, Account);
        Assert.isType(connection.hub, Hub);
        Assert.areEqual('CT-5887-6537', connection.id);
        Assert.areEqual('test', connection.type);
        Assert.areEqual('PA-855-748', connection.provider.id);
        Assert.areEqual('CB Demo Staging Provider Brand 507', connection.provider.name);
        Assert.areEqual('VA-840-266', connection.vendor.id);
        Assert.areEqual('Adrian\'s Inc', connection.vendor.name);
        Assert.areEqual('HB-5304-5271', connection.hub.id);
        Assert.areEqual('cb1.conn.rocks', connection.hub.name);
    }

    @Test
    public function testGetConnectionsKo() {
        final connections = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getConnections();
        Assert.isType(connections, Collection);
        Assert.areEqual(0, connections.length());
    }

    @Test
    public function testListItemsOk() {
        final items = Product.get('PRD-783-317-575').listItems(null);
        Assert.areEqual(2, items.length());
        Assert.areEqual('PRD-783-317-575-0001', items.get(0).id);
        Assert.areEqual('PRD-783-317-575-0002', items.get(1).id);
    }

    @Test
    public function testListItemsKo() {
        final items = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listItems(null);
        Assert.areEqual(0, items.length());
    }

    @Test
    public function testListParametersOk() {
        final params = Product.get('PRD-783-317-575').listParameters(null);
        Assert.areEqual(2, params.length());
        Assert.areEqual('military-saolas-vrqh', params.get(0).id);
        Assert.areEqual('sure-crickets-5x24', params.get(1).id);
    }

    @Test
    public function testGetParametersKo() {
        final params = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listParameters(null);
        Assert.areEqual(0, params.length());
    }

    @Test
    public function testGetTemplatesOk() {
        final templates = Product.get('PRD-783-317-575').getTemplates();
        Assert.areEqual(3, templates.length());
        Assert.areEqual('TL-191-299-324', templates.get(0).id);
        Assert.areEqual('TL-244-935-471', templates.get(1).id);
        Assert.areEqual('TL-921-532-627', templates.get(2).id);
    }

    public function testGetTemplatesKo() {
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final templates = product.getTemplates();
        Assert.areEqual(0, templates.length());
    }

    @Test
    public function testGetVersionsOk() {
        final versions = Product.get('PRD-783-317-575').getVersions();
        Assert.areEqual(1, versions.length());
        Assert.areEqual('PRD-783-317-575', versions.get(0).id);
        Assert.areEqual(2, versions.get(0).version);
    }

    @Test
    public function testGetVersionsKo() {
        final versions = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getVersions();
        Assert.areEqual(0, versions.length());
    }

    @Test
    public function testGetVersionOk() {
        final version = Product.get('PRD-783-317-575').getVersion(2);
        Assert.areEqual('PRD-783-317-575', version.id);
        Assert.areEqual(2, version.version);
    }

    @Test
    public function testGetVersionKo() {
        Assert.isNull(Product.get('PRD-783-317-575').getVersion(1));
    }

    @Test
    public function testGetVersionActionsOk() {
        final actions = Product.get('PRD-783-317-575').getVersionActions(2);
        Assert.areEqual(1, actions.length());
        Assert.areEqual('sso_action', actions.get(0).id);
    }

    @Test
    public function testGetVersionActionsKo() {
        final actions = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getVersionActions(2);
        Assert.areEqual(0, actions.length());
    }

    @Test
    public function testGetVersionActionOk() {
        final action = Product.get('PRD-783-317-575').getVersionAction(2, 'sso_action');
        Assert.areEqual('sso_action', action.id);
    }

    @Test
    public function testGetVersionActionKo() {
        Assert.isNull(Product.get('PRD-783-317-575').getVersionAction(2, 'invalid_id'));
    }

    @Test
    public function testGetVersionActionLinkOk() {
        final link = Product.get('PRD-783-317-575').getVersionActionLink(2, 'sso_action');
        Assert.areEqual('https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi', link);
    }

    @Test
    public function testGetVersionActionLinkKo() {
        final link = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getVersionActionLink(2, 'sso_action');
        Assert.areEqual('', link);
    }

    @Test
    public function testGetVersionItemsOk() {
        final items = Product.get('PRD-783-317-575').getVersionItems(2);
        Assert.areEqual(2, items.length());
        Assert.areEqual('PRD-783-317-575-0001', items.get(0).id);
        Assert.areEqual('PRD-783-317-575-0002', items.get(1).id);
    }

    @Test
    public function testGetVersionItemsKo() {
        final items = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getVersionItems(2);
        Assert.areEqual(0, items.length());
    }

    @Test
    public function testGetVersionParametersOk() {
        final params = Product.get('PRD-783-317-575').getVersionParameters(2);
        Assert.areEqual(2, params.length());
        Assert.areEqual('military-saolas-vrqh', params.get(0).id);
        Assert.areEqual('sure-crickets-5x24', params.get(1).id);
    }

    @Test
    public function testGetVersionParametersKo() {
        final params = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getVersionParameters(2);
        Assert.areEqual(0, params.length());
    }

    @Test
    public function testGetVersionTemplatesOk() {
        final templates = Product.get('PRD-783-317-575').getVersionTemplates(2);
        Assert.areEqual(3, templates.length());
        Assert.areEqual('TL-191-299-324', templates.get(0).id);
        Assert.areEqual('TL-244-935-471', templates.get(1).id);
        Assert.areEqual('TL-921-532-627', templates.get(2).id);
    }

    @Test
    public function testGetVersionTemplatesKo() {
        final templates = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getVersionTemplates(2);
        Assert.areEqual(0, templates.length());
    }

    @Test
    public function testListConfigurationsOk() {
        final configs = Product.get('PRD-783-317-575').listConfigurations(null);
        Assert.areEqual(1, configs.length());
        Assert.areEqual('id', configs.get(0).parameter.id);
    }

    @Test
    public function testListConfigurationsKo() {
        final configs = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listConfigurations(null);
        Assert.areEqual(0, configs.length());
    }

    @Test
    public function testSetProductConfigurationParamOk() {
        final param = Model.parse(ProductConfigurationParam, '{"parameter": {"id": "XXX"}}');
        final product = Product.get('PRD-783-317-575');
        final result = product.setConfigurationParam(param);
        Assert.areEqual('XXX', result.parameter.id);
    }

    @Test
    public function testSetProductConfigurationParamKo() {
        final param = Model.parse(ProductConfigurationParam, '{"parameter": {"id": "XXX"}}');
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        Assert.isNull(product.setConfigurationParam(param));
    }

    @Test
    public function testListAgreementsOk() {
        final agreements = Product.get('PRD-783-317-575').listAgreements(null);
        Assert.areEqual(1, agreements.length());
        Assert.areEqual('AGP-884-348-731', agreements.get(0).id);
    }

    @Test
    public function testListAgreementsKo() {
        final agreements = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listAgreements(null);
        Assert.areEqual(0, agreements.length());
    }

    @Test
    public function testListMediaOk() {
        final media = Product.get('PRD-783-317-575').listMedia(null);
        Assert.areEqual(1, media.length());
        Assert.areEqual('PRM-00000-00000-00000', media.get(0).id);
    }

    @Test
    public function testListMediaKo() {
        final media = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listMedia(null);
        Assert.areEqual(0, media.length());
    }

    @Test
    public function testCreateMediaOk() {
        final media = Product.get('PRD-783-317-575').createMedia();
        Assert.areEqual('PRM-00000-00000-00000', media.id);
    }

    @Test
    public function testCreateMediaKo() {
        final media = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').createMedia();
        Assert.areEqual(null, media);
    }

    @Test
    public function testGetMediaOk() {
        final media = Product.get('PRD-783-317-575').getMedia('PRM-00000-00000-00000');
        Assert.areEqual('PRM-00000-00000-00000', media.id);
    }

    @Test
    public function testGetMediaKo() {
        final media = Product.get('PRD-783-317-575').getMedia('PRM-XXXXX-XXXXX-XXXXX');
        Assert.areEqual(null, media);
    }

    @Test
    public function testUpdateMediaOk() {
        final media = Model.parse(Media, '{"id": "PRM-00000-00000-00000"}');
        final result = Product.get('PRD-783-317-575').updateMedia(media);
        Assert.areEqual('PRM-00000-00000-00000', result.id);
    }

    @Test
    public function testUpdateMediaKo() {
        final media = Model.parse(Media, '{"id": "PRM-XXXXX-XXXXX-XXXXX"}');
        final result = Product.get('PRD-783-317-575').updateMedia(media);
        Assert.areEqual(null, result);
    }

    @Test
    public function testDeleteMediaOk() {
        final result = Product.get('PRD-783-317-575').deleteMedia('PRM-00000-00000-00000');
        Assert.areEqual('PRM-00000-00000-00000', result.id);
    }

    @Test
    public function testDeleteMediaKo() {
        final result = Product.get('PRD-783-317-575').deleteMedia('PRM-XXXXX-XXXXX-XXXXX');
        Assert.areEqual(null, result);
    }
}

class ProductApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/products.json';
    static final ACTIONS_FILE = 'test/unit/data/actions.json';
    static final AGREEMENTS_FILE = 'test/unit/data/agreements.json';
    static final CONFIGURATIONS_FILE = 'test/unit/data/configurations.json';
    static final CONNECTIONS_FILE = 'test/unit/data/connections.json';
    static final ITEMS_FILE = 'test/unit/data/items.json';
    static final MEDIAS_FILE = 'test/unit/data/medias.json';
    static final PARAMS_FILE = 'test/unit/data/params.json';
    static final TEMPLATES_FILE = 'test/unit/data/templates.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/products':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575':
                        final product = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(product), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/actions':
                        return new Response(200, File.getContent(ACTIONS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/actions/sso_action':
                        final action = Json.parse(File.getContent(ACTIONS_FILE))[0];
                        return new Response(200, Json.stringify(action), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/actions/sso_action/actionLink':
                        return new Response(200, '{"link": "https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi"}', null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/connections':
                        return new Response(200, File.getContent(CONNECTIONS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/items':
                        return new Response(200, File.getContent(ITEMS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/parameters':
                        return new Response(200, File.getContent(PARAMS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/templates':
                        return new Response(200, File.getContent(TEMPLATES_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2':
                        final product = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(product), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2/actions':
                        return new Response(200, File.getContent(ACTIONS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2/actions/sso_action':
                        final action = Json.parse(File.getContent(ACTIONS_FILE))[0];
                        return new Response(200, Json.stringify(action), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2/actions/sso_action/actionLink':
                        return new Response(200, '{"link": "https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi"}', null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2/items':
                        return new Response(200, File.getContent(ITEMS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2/parameters':
                        return new Response(200, File.getContent(PARAMS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/versions/2/templates':
                        return new Response(200, File.getContent(TEMPLATES_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/configurations':
                        return new Response(200, File.getContent(CONFIGURATIONS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/agreements':
                        return new Response(200, File.getContent(AGREEMENTS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/media':
                        return new Response(200, File.getContent(MEDIAS_FILE), null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/media/PRM-00000-00000-00000':
                        final media = Json.parse(File.getContent(MEDIAS_FILE))[0];
                        return new Response(200, Json.stringify(media), null);
                }
            case 'POST':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/configurations':
                        return new Response(200, body, null);
                    case 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/media':
                        final media = Json.parse(File.getContent(MEDIAS_FILE))[0];
                        return new Response(200, Json.stringify(media), null);
                }
            case 'PUT':
                if (url == 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/media/PRM-00000-00000-00000') {
                    return new Response(200, body, null);
                }
            case 'DELETE':
                if (url == 'https://api.conn.rocks/public/v1/products/PRD-783-317-575/media/PRM-00000-00000-00000') {
                    final media = Json.parse(File.getContent(MEDIAS_FILE))[0];
                    return new Response(200, Json.stringify(media), null);
                }
        }
        return new Response(404, null, null);
    }
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
                return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
