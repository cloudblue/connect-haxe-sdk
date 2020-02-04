/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
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
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class ProductTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'test.mocks.GeneralApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final products = Product.list(null);
        Assert.isType(products, Collection);
        Assert.areEqual(1, products.length());
        Assert.isType(products.get(0), Product);
        Assert.areEqual('PRD-783-317-575', products.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProducts'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listProducts', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
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

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProduct'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProduct', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final product = Product.get('PRD-XXX-XXX-XXX');
        Assert.isNull(product);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProduct'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProduct', 0).toString());
    }


    @Test
    public function testListActionsOk() {
        // Check subject
        final actions = Product.get('PRD-783-317-575').listActions(null);
        Assert.isType(actions, Collection);
        Assert.areEqual(1, actions.length());
        Assert.isType(actions.get(0), Action);
        Assert.areEqual('sso_action', actions.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductActions'));
        Assert.areEqual(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductActions', 0).toString());
    }


    @Test
    public function testListActionsKo() {
        // Check subject
        final actions = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listActions(null);
        Assert.isType(actions, Collection);
        Assert.areEqual(0, actions.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductActions'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductActions', 0).toString());
    }


    @Test
    public function testGetActionOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getAction('sso_action');
        Assert.isType(action, Action);
        Assert.areEqual('sso_action', action.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductAction'));
        Assert.areEqual(
            ['PRD-783-317-575', 'sso_action'].toString(),
            apiMock.callArgs('getProductAction', 0).toString());
    }


    @Test
    public function testGetActionKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getAction('invalid-id');
        Assert.isNull(action);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductAction'));
        Assert.areEqual(
            ['PRD-783-317-575', 'invalid-id'].toString(),
            apiMock.callArgs('getProductAction', 0).toString());
    }


    @Test
    public function testGetActionKo2() {
        // Check subject
        final action = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getAction('sso_action');
        Assert.isNull(action);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductAction'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', 'sso_action'].toString(),
            apiMock.callArgs('getProductAction', 0).toString());
    }


    @Test
    public function testGetActionLinkOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final link = product.getActionLink('sso_action');
        Assert.areEqual('https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductActionLink'));
        Assert.areEqual(
            ['PRD-783-317-575', 'sso_action'].toString(),
            apiMock.callArgs('getProductActionLink', 0).toString());
    }


    @Test
    public function testGetActionLinkKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final link = product.getActionLink('invalid_id');
        Assert.areEqual('', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductActionLink'));
        Assert.areEqual(
            ['PRD-783-317-575', 'invalid_id'].toString(),
            apiMock.callArgs('getProductActionLink', 0).toString());
    }


    @Test
    public function testGetConnectionsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final connections = product.getConnections();
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

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductConnections'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductConnections', 0).toString());
    }


    @Test
    public function testGetConnectionsKo() {
        // Check subject
        final connections = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getConnections();
        Assert.isType(connections, Collection);
        Assert.areEqual(0, connections.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductConnections'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductConnections', 0).toString());
    }


    @Test
    public function testGetItemsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final items = product.getItems();
        Assert.areEqual(2, items.length());
        Assert.areEqual('PRD-783-317-575-0001', items.get(0).id);
        Assert.areEqual('PRD-783-317-575-0002', items.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductItems'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductItems', 0).toString());
    }


    @Test
    public function testGetItemsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final items = product.getItems();
        Assert.areEqual(0, items.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductItems'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductItems', 0).toString());
    }


    @Test
    public function testGetParametersOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final params = product.getParameters();
        Assert.areEqual(2, params.length());
        Assert.areEqual('military-saolas-vrqh', params.get(0).id);
        Assert.areEqual('sure-crickets-5x24', params.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductParameters'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductParameters', 0).toString());
    }


    @Test
    public function testGetParametersKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final params = product.getParameters();
        Assert.areEqual(0, params.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductParameters'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductParameters', 0).toString());
    }


    @Test
    public function testGetTemplatesOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final templates = product.getTemplates();
        Assert.areEqual(3, templates.length());
        Assert.areEqual('TL-191-299-324', templates.get(0).id);
        Assert.areEqual('TL-244-935-471', templates.get(1).id);
        Assert.areEqual('TL-921-532-627', templates.get(2).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductTemplates'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductTemplates', 0).toString());
    }


    @Test
    public function testGetTemplatesKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final templates = product.getTemplates();
        Assert.areEqual(0, templates.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductTemplates'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductTemplates', 0).toString());
    }


    @Test
    public function testGetVersionsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final versions = product.getVersions();
        Assert.areEqual(1, versions.length());
        Assert.areEqual('PRD-783-317-575', versions.get(0).id);
        Assert.areEqual(2, versions.get(0).version);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersions'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductVersions', 0).toString());
    }


    @Test
    public function testGetVersionsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final versions = product.getVersions();
        Assert.areEqual(0, versions.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersions'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductVersions', 0).toString());
    }


    @Test
    public function testGetVersionOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final version = product.getVersion(2);
        Assert.areEqual('PRD-783-317-575', version.id);
        Assert.areEqual(2, version.version);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersion'));
        Assert.areEqual(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersion', 0).toString());
    }


    @Test
    public function testGetVersionKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final version = product.getVersion(1);
        Assert.isNull(version);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersion'));
        Assert.areEqual(
            ['PRD-783-317-575', '1'].toString(),
            apiMock.callArgs('getProductVersion', 0).toString());
    }


    @Test
    public function testGetVersionActionsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final actions = product.getVersionActions(2);
        Assert.areEqual(1, actions.length());
        Assert.areEqual('sso_action', actions.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionActions'));
        Assert.areEqual(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionActions', 0).toString());
    }


    @Test
    public function testGetVersionActionsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final actions = product.getVersionActions(2);
        Assert.areEqual(0, actions.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionActions'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionActions', 0).toString());
    }


    @Test
    public function testGetVersionActionOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getVersionAction(2, 'sso_action');
        Assert.areEqual('sso_action', action.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionAction'));
        Assert.areEqual(
            ['PRD-783-317-575', '2', 'sso_action'].toString(),
            apiMock.callArgs('getProductVersionAction', 0).toString());
    }


    @Test
    public function testGetVersionActionKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getVersionAction(2, 'invalid_id');
        Assert.isNull(action);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionAction'));
        Assert.areEqual(
            ['PRD-783-317-575', '2', 'invalid_id'].toString(),
            apiMock.callArgs('getProductVersionAction', 0).toString());
    }


    @Test
    public function testGetVersionActionLinkOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final link = product.getVersionActionLink(2, 'sso_action');
        Assert.areEqual('https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionActionLink'));
        Assert.areEqual(
            ['PRD-783-317-575', '2', 'sso_action'].toString(),
            apiMock.callArgs('getProductVersionActionLink', 0).toString());
    }


    @Test
    public function testGetVersionActionLinkKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final link = product.getVersionActionLink(2, 'sso_action');
        Assert.areEqual('', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionActionLink'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', '2', 'sso_action'].toString(),
            apiMock.callArgs('getProductVersionActionLink', 0).toString());
    }


    @Test
    public function testGetVersionItemsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final items = product.getVersionItems(2);
        Assert.areEqual(2, items.length());
        Assert.areEqual('PRD-783-317-575-0001', items.get(0).id);
        Assert.areEqual('PRD-783-317-575-0002', items.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionItems'));
        Assert.areEqual(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionItems', 0).toString());
    }


    @Test
    public function testGetVersionItemsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final items = product.getVersionItems(2);
        Assert.areEqual(0, items.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionItems'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionItems', 0).toString());
    }


    @Test
    public function testGetVersionParametersOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final params = product.getVersionParameters(2);
        Assert.areEqual(2, params.length());
        Assert.areEqual('military-saolas-vrqh', params.get(0).id);
        Assert.areEqual('sure-crickets-5x24', params.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionParameters'));
        Assert.areEqual(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionParameters', 0).toString());
    }


    @Test
    public function testGetVersionParametersKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final params = product.getVersionParameters(2);
        Assert.areEqual(0, params.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionParameters'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionParameters', 0).toString());
    }


    @Test
    public function testGetVersionTemplatesOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final templates = product.getVersionTemplates(2);
        Assert.areEqual(3, templates.length());
        Assert.areEqual('TL-191-299-324', templates.get(0).id);
        Assert.areEqual('TL-244-935-471', templates.get(1).id);
        Assert.areEqual('TL-921-532-627', templates.get(2).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionTemplates'));
        Assert.areEqual(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionTemplates', 0).toString());
    }


    @Test
    public function testGetVersionTemplatesKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final templates = product.getVersionTemplates(2);
        Assert.areEqual(0, templates.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductVersionTemplates'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionTemplates', 0).toString());
    }


    @Test
    public function testListConfigurationsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final configs = product.listConfigurations(null);
        Assert.areEqual(1, configs.length());
        Assert.areEqual('id', configs.get(0).parameter.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductConfigurations'));
        Assert.areEqual(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductConfigurations', 0).toString());
    }


    @Test
    public function testListConfigurationsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final configs = product.listConfigurations(null);
        Assert.areEqual(0, configs.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductConfigurations'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductConfigurations', 0).toString());
    }


    @Test
    public function testSetProductConfigurationParamOk() {
        // Check subject
        final param = Model.parse(ProductConfigurationParam, '{"parameter": {"id": "XXX"}}');
        final product = Product.get('PRD-783-317-575');
        final result = product.setConfigurationParam(param);
        Assert.areEqual('XXX', result.parameter.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('setProductConfigurationParam'));
        Assert.areEqual(
            ['PRD-783-317-575', param.toString()].toString(),
            apiMock.callArgs('setProductConfigurationParam', 0).toString());
    }


    @Test
    public function testSetProductConfigurationParamKo() {
        // Check subject
        final param = Model.parse(ProductConfigurationParam, '{"parameter": {"id": "XXX"}}');
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final result = product.setConfigurationParam(param);
        Assert.isNull(result);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('setProductConfigurationParam'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', param.toString()].toString(),
            apiMock.callArgs('setProductConfigurationParam', 0).toString());
    }


    @Test
    public function testListAgreementsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final agreements = product.listAgreements(null);
        Assert.areEqual(1, agreements.length());
        Assert.areEqual('AGP-884-348-731', agreements.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductAgreements'));
        Assert.areEqual(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductAgreements', 0).toString());
    }


    @Test
    public function testListAgreementsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final agreements = product.listAgreements(null);
        Assert.areEqual(0, agreements.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductAgreements'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductAgreements', 0).toString());
    }


    @Test
    public function testListMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.listMedia(null);
        Assert.areEqual(1, media.length());
        Assert.areEqual('PRM-00000-00000-00000', media.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductMedia', 0).toString());
    }


    @Test
    public function testListMediaKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final media = product.listMedia(null);
        Assert.areEqual(0, media.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listProductMedia'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductMedia', 0).toString());
    }


    @Test
    public function testCreateMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.createMedia();
        Assert.areEqual('PRM-00000-00000-00000', media.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('createProductMedia', 0).toString());
    }


    @Test
    public function testCreateMediaKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final media = product.createMedia();
        Assert.areEqual(null, media);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createProductMedia'));
        Assert.areEqual(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('createProductMedia', 0).toString());
    }


    @Test
    public function testGetMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.getMedia('PRM-00000-00000-00000');
        Assert.areEqual('PRM-00000-00000-00000', media.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', 'PRM-00000-00000-00000'].toString(),
            apiMock.callArgs('getProductMedia', 0).toString());
    }


    @Test
    public function testGetMediaKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.getMedia('PRM-XXXXX-XXXXX-XXXXX');
        Assert.areEqual(null, media);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', 'PRM-XXXXX-XXXXX-XXXXX'].toString(),
            apiMock.callArgs('getProductMedia', 0).toString());
    }


    @Test
    public function testUpdateMediaOk() {
        // Check subject
        final media = Model.parse(Media, '{"id": "PRM-00000-00000-00000"}');
        final product = Product.get('PRD-783-317-575');
        final result = product.updateMedia(media);
        Assert.areEqual('PRM-00000-00000-00000', result.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', 'PRM-00000-00000-00000', media.toString()].toString(),
            apiMock.callArgs('updateProductMedia', 0).toString());
    }


    @Test
    public function testUpdateMediaKo() {
        // Check subject
        final media = Model.parse(Media, '{"id": "PRM-XXXXX-XXXXX-XXXXX"}');
        final product = Product.get('PRD-783-317-575');
        final result = product.updateMedia(media);
        Assert.areEqual(null, result);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', 'PRM-XXXXX-XXXXX-XXXXX', media.toString()].toString(),
            apiMock.callArgs('updateProductMedia', 0).toString());
    }


    @Test
    public function testDeleteMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final result = product.deleteMedia('PRM-00000-00000-00000');
        Assert.areEqual('PRM-00000-00000-00000', result.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('deleteProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', 'PRM-00000-00000-00000'].toString(),
            apiMock.callArgs('deleteProductMedia', 0).toString());
    }


    @Test
    public function testDeleteMediaKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final result = product.deleteMedia('PRM-XXXXX-XXXXX-XXXXX');
        Assert.areEqual(null, result);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('deleteProductMedia'));
        Assert.areEqual(
            ['PRD-783-317-575', 'PRM-XXXXX-XXXXX-XXXXX'].toString(),
            apiMock.callArgs('deleteProductMedia', 0).toString());
    }
}
