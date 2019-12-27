/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.models.Account;
import connect.Collection;
import connect.Dictionary;
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
import tests.mocks.Mock;


class ProductTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        final products = Product.list(null);
        assertTrue(Std.is(products, Collection));
        assertEquals(1, products.length());
        assertTrue(Std.is(products.get(0), Product));
        assertEquals('PRD-783-317-575', products.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProducts'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listProducts', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        assertTrue(Std.is(product, Product));
        assertTrue(Std.is(product.configurations, Configurations));
        assertTrue(Std.is(product.customerUiSettings, CustomerUiSettings));
        assertTrue(Std.is(product.customerUiSettings.downloadLinks, Collection));
        assertEquals(2, product.customerUiSettings.downloadLinks.length());
        assertTrue(Std.is(product.customerUiSettings.downloadLinks.get(0), DownloadLink));
        assertTrue(Std.is(product.customerUiSettings.documents, Collection));
        assertEquals(2, product.customerUiSettings.documents.length());
        assertTrue(Std.is(product.customerUiSettings.documents.get(0), Document));
        assertTrue(Std.is(product.category, Category));
        assertTrue(Std.is(product.owner, Account));
        assertTrue(Std.is(product.stats, ProductStats));
        assertTrue(Std.is(product.stats.agreements, ProductStatsInfo));
        assertTrue(Std.is(product.stats.contracts, ProductStatsInfo));
        assertEquals('PRD-783-317-575', product.id);
        assertEquals('Test Product', product.name);
        assertEquals('https://provider.connect.cloud.im/media/dapper-lynxes-35/mj301/media/mj301-logo.png', product.icon);
        assertEquals('', product.shortDescription);
        assertEquals('', product.detailedDescription);
        assertEquals(2, product.version);
        assertEquals(null, product.publishedAt);
        assertEquals(true, product.configurations.suspendResumeSupported);
        assertEquals(true, product.configurations.requiresResellerInformation);
        assertEquals('description', product.customerUiSettings.description);
        assertEquals('short description', product.customerUiSettings.gettingStarted);
        final link = product.customerUiSettings.downloadLinks.get(0);
        assertEquals('Windows', link.title);
        assertEquals('https://fallball.io/download/windows', link.url);
        final document = product.customerUiSettings.documents.get(0);
        assertEquals('Admin Manual', document.title);
        assertEquals('https://fallball.io/manual/admin', document.url);
        assertEquals('CAT-00000', product.category.id);
        assertEquals('Category', product.category.name);
        assertEquals('VA-000-000', product.owner.id);
        assertEquals('Vendor', product.owner.name);
        assertEquals(false, product.latest);
        final stats = product.stats;
        assertEquals(0, stats.listings);
        assertEquals(0, stats.agreements.distribution);
        assertEquals(0, stats.agreements.sourcing);
        assertEquals(0, stats.contracts.distribution);
        assertEquals(0, stats.contracts.sourcing);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProduct'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProduct', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final product = Product.get('PRD-XXX-XXX-XXX');
        assertTrue(product == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProduct'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProduct', 0).toString());
    }


    public function testListActionsOk() {
        // Check subject
        final actions = Product.get('PRD-783-317-575').listActions(null);
        assertTrue(Std.is(actions, Collection));
        assertEquals(1, actions.length());
        assertTrue(Std.is(actions.get(0), Action));
        assertEquals('sso_action', actions.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductActions'));
        assertEquals(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductActions', 0).toString());
    }


    public function testListActionsKo() {
        // Check subject
        final actions = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').listActions(null);
        assertTrue(Std.is(actions, Collection));
        assertEquals(0, actions.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductActions'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductActions', 0).toString());
    }


    public function testGetActionOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getAction('sso_action');
        assertTrue(Std.is(action, Action));
        assertEquals('sso_action', action.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductAction'));
        assertEquals(
            ['PRD-783-317-575', 'sso_action'].toString(),
            apiMock.callArgs('getProductAction', 0).toString());
    }


    public function testGetActionKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getAction('invalid-id');
        assertTrue(action == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductAction'));
        assertEquals(
            ['PRD-783-317-575', 'invalid-id'].toString(),
            apiMock.callArgs('getProductAction', 0).toString());
    }


    public function testGetActionKo2() {
        // Check subject
        final action = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getAction('sso_action');
        assertTrue(action == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductAction'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', 'sso_action'].toString(),
            apiMock.callArgs('getProductAction', 0).toString());
    }


    public function testGetActionLinkOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final link = product.getActionLink('sso_action');
        assertEquals('https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductActionLink'));
        assertEquals(
            ['PRD-783-317-575', 'sso_action'].toString(),
            apiMock.callArgs('getProductActionLink', 0).toString());
    }


    public function testGetActionLinkKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final link = product.getActionLink('invalid_id');
        assertEquals('', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductActionLink'));
        assertEquals(
            ['PRD-783-317-575', 'invalid_id'].toString(),
            apiMock.callArgs('getProductActionLink', 0).toString());
    }


    public function testGetConnectionsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final connections = product.getConnections();
        assertTrue(Std.is(connections, Collection));
        assertEquals(1, connections.length());
        final connection = connections.get(0);
        assertTrue(Std.is(connection, Connection));
        assertTrue(Std.is(connection.provider, Account));
        assertTrue(Std.is(connection.vendor, Account));
        assertTrue(Std.is(connection.hub, Hub));
        assertEquals('CT-5887-6537', connection.id);
        assertEquals('test', connection.type);
        assertEquals('PA-855-748', connection.provider.id);
        assertEquals('CB Demo Staging Provider Brand 507', connection.provider.name);
        assertEquals('VA-840-266', connection.vendor.id);
        assertEquals('Adrian\'s Inc', connection.vendor.name);
        assertEquals('HB-5304-5271', connection.hub.id);
        assertEquals('cb1.conn.rocks', connection.hub.name);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductConnections'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductConnections', 0).toString());
    }


    public function testGetConnectionsKo() {
        // Check subject
        final connections = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}').getConnections();
        assertTrue(Std.is(connections, Collection));
        assertEquals(0, connections.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductConnections'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductConnections', 0).toString());
    }


    public function testGetItemsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final items = product.getItems();
        assertEquals(2, items.length());
        assertEquals('PRD-783-317-575-0001', items.get(0).id);
        assertEquals('PRD-783-317-575-0002', items.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductItems'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductItems', 0).toString());
    }


    public function testGetItemsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final items = product.getItems();
        assertEquals(0, items.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductItems'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductItems', 0).toString());
    }


    public function testGetParametersOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final params = product.getParameters();
        assertEquals(2, params.length());
        assertEquals('military-saolas-vrqh', params.get(0).id);
        assertEquals('sure-crickets-5x24', params.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductParameters'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductParameters', 0).toString());
    }


    public function testGetParametersKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final params = product.getParameters();
        assertEquals(0, params.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductParameters'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductParameters', 0).toString());
    }


    public function testGetTemplatesOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final templates = product.getTemplates();
        assertEquals(3, templates.length());
        assertEquals('TL-191-299-324', templates.get(0).id);
        assertEquals('TL-244-935-471', templates.get(1).id);
        assertEquals('TL-921-532-627', templates.get(2).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductTemplates'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductTemplates', 0).toString());
    }


    public function testGetTemplatesKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final templates = product.getTemplates();
        assertEquals(0, templates.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductTemplates'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductTemplates', 0).toString());
    }


    public function testGetVersionsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final versions = product.getVersions();
        assertEquals(1, versions.length());
        assertEquals('PRD-783-317-575', versions.get(0).id);
        assertEquals(2, versions.get(0).version);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersions'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('getProductVersions', 0).toString());
    }


    public function testGetVersionsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final versions = product.getVersions();
        assertEquals(0, versions.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersions'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getProductVersions', 0).toString());
    }


    public function testGetVersionOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final version = product.getVersion(2);
        assertEquals('PRD-783-317-575', version.id);
        assertEquals(2, version.version);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersion'));
        assertEquals(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersion', 0).toString());
    }


    public function testGetVersionKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final version = product.getVersion(1);
        assertTrue(version == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersion'));
        assertEquals(
            ['PRD-783-317-575', '1'].toString(),
            apiMock.callArgs('getProductVersion', 0).toString());
    }


    public function testGetVersionActionsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final actions = product.getVersionActions(2);
        assertEquals(1, actions.length());
        assertEquals('sso_action', actions.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionActions'));
        assertEquals(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionActions', 0).toString());
    }


    public function testGetVersionActionsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final actions = product.getVersionActions(2);
        assertEquals(0, actions.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionActions'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionActions', 0).toString());
    }


    public function testGetVersionActionOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getVersionAction(2, 'sso_action');
        assertEquals('sso_action', action.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionAction'));
        assertEquals(
            ['PRD-783-317-575', '2', 'sso_action'].toString(),
            apiMock.callArgs('getProductVersionAction', 0).toString());
    }


    public function testGetVersionActionKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final action = product.getVersionAction(2, 'invalid_id');
        assertTrue(action == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionAction'));
        assertEquals(
            ['PRD-783-317-575', '2', 'invalid_id'].toString(),
            apiMock.callArgs('getProductVersionAction', 0).toString());
    }


    public function testGetVersionActionLinkOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final link = product.getVersionActionLink(2, 'sso_action');
        assertTrue(link == 'https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi');

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionActionLink'));
        assertEquals(
            ['PRD-783-317-575', '2', 'sso_action'].toString(),
            apiMock.callArgs('getProductVersionActionLink', 0).toString());
    }


    public function testGetVersionActionLinkKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final link = product.getVersionActionLink(2, 'sso_action');
        assertEquals('', link);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionActionLink'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', '2', 'sso_action'].toString(),
            apiMock.callArgs('getProductVersionActionLink', 0).toString());
    }


    public function testGetVersionItemsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final items = product.getVersionItems(2);
        assertEquals(2, items.length());
        assertEquals('PRD-783-317-575-0001', items.get(0).id);
        assertEquals('PRD-783-317-575-0002', items.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionItems'));
        assertEquals(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionItems', 0).toString());
    }


    public function testGetVersionItemsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final items = product.getVersionItems(2);
        assertEquals(0, items.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionItems'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionItems', 0).toString());
    }


    public function testGetVersionParametersOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final params = product.getVersionParameters(2);
        assertEquals(2, params.length());
        assertEquals('military-saolas-vrqh', params.get(0).id);
        assertEquals('sure-crickets-5x24', params.get(1).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionParameters'));
        assertEquals(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionParameters', 0).toString());
    }


    public function testGetVersionParametersKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final params = product.getVersionParameters(2);
        assertEquals(0, params.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionParameters'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionParameters', 0).toString());
    }


    public function testGetVersionTemplatesOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final templates = product.getVersionTemplates(2);
        assertEquals(3, templates.length());
        assertEquals('TL-191-299-324', templates.get(0).id);
        assertEquals('TL-244-935-471', templates.get(1).id);
        assertEquals('TL-921-532-627', templates.get(2).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionTemplates'));
        assertEquals(
            ['PRD-783-317-575', '2'].toString(),
            apiMock.callArgs('getProductVersionTemplates', 0).toString());
    }


    public function testGetVersionTemplatesKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final templates = product.getVersionTemplates(2);
        assertEquals(0, templates.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductVersionTemplates'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', '2'].toString(),
            apiMock.callArgs('getProductVersionTemplates', 0).toString());
    }


    public function testListConfigurationsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final configs = product.listConfigurations(null);
        assertEquals(1, configs.length());
        assertEquals('id', configs.get(0).parameter.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductConfigurations'));
        assertEquals(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductConfigurations', 0).toString());
    }


    public function testListConfigurationsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final configs = product.listConfigurations(null);
        assertEquals(0, configs.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductConfigurations'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductConfigurations', 0).toString());
    }


    public function testSetProductConfigurationParamOk() {
        // Check subject
        final param = Model.parse(ProductConfigurationParam, '{"parameter": {"id": "XXX"}}');
        final product = Product.get('PRD-783-317-575');
        final result = product.setConfigurationParam(param);
        assertEquals('XXX', result.parameter.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('setProductConfigurationParam'));
        assertEquals(
            ['PRD-783-317-575', param.toString()].toString(),
            apiMock.callArgs('setProductConfigurationParam', 0).toString());
    }


    public function testSetProductConfigurationParamKo() {
        // Check subject
        final param = Model.parse(ProductConfigurationParam, '{"parameter": {"id": "XXX"}}');
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final result = product.setConfigurationParam(param);
        assertTrue(result == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('setProductConfigurationParam'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', param.toString()].toString(),
            apiMock.callArgs('setProductConfigurationParam', 0).toString());
    }


    public function testListAgreementsOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final agreements = product.listAgreements(null);
        assertEquals(1, agreements.length());
        assertEquals('AGP-884-348-731', agreements.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductAgreements'));
        assertEquals(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductAgreements', 0).toString());
    }


    public function testListAgreementsKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final agreements = product.listAgreements(null);
        assertEquals(0, agreements.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductAgreements'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductAgreements', 0).toString());
    }


    public function testListMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.listMedia(null);
        assertEquals(1, media.length());
        assertEquals('PRM-00000-00000-00000', media.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductMedia'));
        assertEquals(
            ['PRD-783-317-575', null].toString(),
            apiMock.callArgs('listProductMedia', 0).toString());
    }


    public function testListMediaKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final media = product.listMedia(null);
        assertEquals(0, media.length());

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listProductMedia'));
        assertEquals(
            ['PRD-XXX-XXX-XXX', null].toString(),
            apiMock.callArgs('listProductMedia', 0).toString());
    }


    public function testCreateMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.createMedia();
        assertEquals('PRM-00000-00000-00000', media.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createProductMedia'));
        assertEquals(
            ['PRD-783-317-575'].toString(),
            apiMock.callArgs('createProductMedia', 0).toString());
    }


    public function testCreateMediaKo() {
        // Check subject
        final product = Model.parse(Product, '{"id": "PRD-XXX-XXX-XXX"}');
        final media = product.createMedia();
        assertEquals(null, media);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createProductMedia'));
        assertEquals(
            ['PRD-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('createProductMedia', 0).toString());
    }


    public function testGetMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.getMedia('PRM-00000-00000-00000');
        assertEquals('PRM-00000-00000-00000', media.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductMedia'));
        assertEquals(
            ['PRD-783-317-575', 'PRM-00000-00000-00000'].toString(),
            apiMock.callArgs('getProductMedia', 0).toString());
    }


    public function testGetMediaKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final media = product.getMedia('PRM-XXXXX-XXXXX-XXXXX');
        assertEquals(null, media);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductMedia'));
        assertEquals(
            ['PRD-783-317-575', 'PRM-XXXXX-XXXXX-XXXXX'].toString(),
            apiMock.callArgs('getProductMedia', 0).toString());
    }


    public function testUpdateMediaOk() {
        // Check subject
        final media = Model.parse(Media, '{"id": "PRM-00000-00000-00000"}');
        final product = Product.get('PRD-783-317-575');
        final result = product.updateMedia(media);
        assertEquals('PRM-00000-00000-00000', result.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('updateProductMedia'));
        assertEquals(
            ['PRD-783-317-575', 'PRM-00000-00000-00000', media.toString()].toString(),
            apiMock.callArgs('updateProductMedia', 0).toString());
    }


    public function testUpdateMediaKo() {
        // Check subject
        final media = Model.parse(Media, '{"id": "PRM-XXXXX-XXXXX-XXXXX"}');
        final product = Product.get('PRD-783-317-575');
        final result = product.updateMedia(media);
        assertEquals(null, result);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('updateProductMedia'));
        assertEquals(
            ['PRD-783-317-575', 'PRM-XXXXX-XXXXX-XXXXX', media.toString()].toString(),
            apiMock.callArgs('updateProductMedia', 0).toString());
    }


    public function testDeleteMediaOk() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final result = product.deleteMedia('PRM-00000-00000-00000');
        assertEquals('PRM-00000-00000-00000', result.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('deleteProductMedia'));
        assertEquals(
            ['PRD-783-317-575', 'PRM-00000-00000-00000'].toString(),
            apiMock.callArgs('deleteProductMedia', 0).toString());
    }


    public function testDeleteMediaKo() {
        // Check subject
        final product = Product.get('PRD-783-317-575');
        final result = product.deleteMedia('PRM-XXXXX-XXXXX-XXXXX');
        assertEquals(null, result);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('deleteProductMedia'));
        assertEquals(
            ['PRD-783-317-575', 'PRM-XXXXX-XXXXX-XXXXX'].toString(),
            apiMock.callArgs('deleteProductMedia', 0).toString());
    }
}
