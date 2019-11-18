package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Account;
import connect.models.Asset;
import connect.models.Configuration;
import connect.models.Connection;
import connect.models.Constraints;
import connect.models.Contact;
import connect.models.ContactInfo;
import connect.models.Contract;
import connect.models.Event;
import connect.models.Events;
import connect.models.Item;
import connect.models.Marketplace;
import connect.models.Model;
import connect.models.Param;
import connect.models.PhoneNumber;
import connect.models.Product;
import connect.models.TierAccount;
import connect.models.Tiers;
import connect.models.User;
import tests.mocks.Mock;


class AssetTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'tests.mocks.FulfillmentApiMock'));
    }


    public function testList() {
        // Check subject
        final assets = Asset.list(null);
        assertTrue(Std.is(assets, Collection));
        assertEquals(2, assets.length());

        // Check first assert
        final asset0 = assets.get(0);
        assertTrue(Std.is(asset0, Asset));
        assertEquals('AS-392-283-000-0', asset0.id);

        // Check second asset
        final asset1 = assets.get(1);
        assertTrue(Std.is(asset1, Asset));
        assertEquals('AS-392-283-001-0', asset1.id);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('listAssets'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listAssets', 0).toString());
    }


    public function testGetOk() {
        // Check asset
        final asset = Asset.get('AS-392-283-000-0');
        assertTrue(Std.is(asset, Asset));
        assertTrue(Std.is(asset.product, Product));
        assertTrue(Std.is(asset.connection, Connection));
        assertTrue(Std.is(asset.connection.provider, Account));
        assertTrue(Std.is(asset.connection.vendor, Account));
        assertTrue(Std.is(asset.contract, Contract));
        assertTrue(Std.is(asset.marketplace, Marketplace));
        assertTrue(Std.is(asset.params, Collection));
        assertEquals(1, asset.params.length());
        assertTrue(Std.is(asset.params.get(0), Param));
        assertTrue(Std.is(asset.params.get(0).valueChoices, Collection));
        assertEquals(0, asset.params.get(0).valueChoices.length());
        assertTrue(Std.is(asset.tiers, Tiers));
        assertTrue(Std.is(asset.tiers.customer, TierAccount));
        assertTrue(Std.is(asset.tiers.customer.contactInfo, ContactInfo));
        assertTrue(Std.is(asset.tiers.customer.contactInfo.contact, Contact));
        assertTrue(Std.is(asset.tiers.customer.contactInfo.contact.phoneNumber, PhoneNumber));
        assertTrue(Std.is(asset.tiers.tier1, TierAccount));
        assertTrue(Std.is(asset.items, Collection));
        assertEquals(5, asset.items.length());
        assertTrue(Std.is(asset.items.get(0), Item));
        assertTrue(Std.is(asset.items.get(0).params, Collection));
        assertEquals(2, asset.items.get(0).params.length());
        assertTrue(Std.is(asset.items.get(0).params.get(0), Param));
        assertTrue(Std.is(asset.items.get(0).params.get(0).constraints, Constraints));
        assertTrue(Std.is(asset.items.get(0).params.get(0).events, Events));
        assertTrue(Std.is(asset.items.get(0).params.get(0).events.created, Event));
        assertTrue(Std.is(asset.items.get(0).params.get(0).events.created.by, User));
        assertTrue(Std.is(asset.configuration, Configuration));
        assertTrue(Std.is(asset.configuration.params, Collection));
        assertEquals(1, asset.configuration.params.length());
        assertTrue(Std.is(asset.configuration.params.get(0), Param));
        assertEquals('AS-392-283-000-0', asset.id);
        assertEquals('processing', asset.status);
        assertEquals('1001000', asset.externalId);
        assertEquals('f90e2ed2-b267-4831-93e6-a6b06874e000', asset.externalUid);
        assertEquals('Fallball 498c84b1-d53318a6', asset.externalName);
        assertEquals('CN-631-322-000', asset.product.id);
        assertEquals('ProductName', asset.product.name);
        assertEquals('CT-9344-000', asset.connection.id);
        assertEquals('production', asset.connection.type);
        assertEquals('PA-063-000', asset.connection.provider.id);
        assertEquals('Connection name', asset.connection.provider.name);
        assertEquals('VA-691-000', asset.connection.vendor.id);
        assertEquals('Vendor Name', asset.connection.vendor.name);
        assertEquals('CRP-00000-00000-00000', asset.contract.id);
        assertEquals('Contract of Program Agreement', asset.contract.name);
        assertEquals('MP-12345', asset.marketplace.id);
        assertEquals('France and territories', asset.marketplace.name);
        assertEquals('/media/PA-239-689/marketplaces/MP-54865/icon.png', asset.marketplace.icon);
        
        final param = asset.params.get(0);
        assertEquals('activationCode', param.id);
        assertEquals('Activation Code', param.name);
        assertEquals('Activation Code', param.description);
        assertEquals('text', param.type);
        assertEquals('value param', param.value);
        assertEquals('', param.valueError);

        final customer = asset.tiers.customer;
        assertEquals('TA-0-7304-8514-7000', customer.id);
        assertEquals('Name', customer.name);
        assertEquals('street A', customer.contactInfo.addressLine1);
        assertEquals('2 2', customer.contactInfo.addressLine2);
        assertEquals('es', customer.contactInfo.country);
        assertEquals('', customer.contactInfo.state);
        assertEquals('Moscow', customer.contactInfo.city);
        assertEquals('08000', customer.contactInfo.postalCode);
        assertEquals('First Name', customer.contactInfo.contact.firstName);
        assertEquals('Last Name', customer.contactInfo.contact.lastName);
        assertEquals('test@email.com', customer.contactInfo.contact.email);
        assertEquals('+7', customer.contactInfo.contact.phoneNumber.countryCode);
        assertEquals('', customer.contactInfo.contact.phoneNumber.areaCode);
        assertEquals('8901298403', customer.contactInfo.contact.phoneNumber.phoneNumber);
        assertEquals('', customer.contactInfo.contact.phoneNumber.extension);
        assertEquals('1001000', customer.externalId);

        final item = asset.items.get(0);
        assertEquals('TEAM_ST3L2T1Y', item.id);
        assertEquals('TEAM-ST3L2T1Y', item.mpn);
        assertEquals('100', item.quantity);
        assertEquals('0', item.oldQuantity);
        assertEquals('XXX', item.globalId);

        final itemParam = item.params.get(0);
        assertEquals('item_parameter', itemParam.id);
        assertEquals('item_parameter', itemParam.description);
        assertEquals('text', itemParam.type);
        assertEquals('Value 1', itemParam.value);
        assertEquals('item_parameter', itemParam.title);
        assertEquals('item', itemParam.scope);
        assertEquals(false, itemParam.constraints.hidden);
        assertEquals(false, itemParam.constraints.required);
        assertEquals(false, itemParam.constraints.unique);
        assertEquals('2019-08-26T10:42:56+00:00', itemParam.events.created.at);
        assertEquals('UR-841-574-187', itemParam.events.created.by.id);
        assertEquals('Marc Serrat', itemParam.events.created.by.name);
        assertEquals('2019-08-27T14:21:23+00:00', itemParam.events.updated.at);
        assertEquals('UR-841-574-187', itemParam.events.updated.by.id);
        assertEquals('Marc Serrat', itemParam.events.updated.by.name);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAsset'));
        assertEquals(
            ['AS-392-283-000-0'].toString(),
            apiMock.callArgs('getAsset', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final asset = Asset.get('AS-XXX-XXX-XXX-X');
        assertTrue(asset == null);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAsset'));
        assertEquals(
            ['AS-XXX-XXX-XXX-X'].toString(),
            apiMock.callArgs('getAsset', 0).toString());
    }


    public function testGetRequests() {
        // Check subject
        final asset = Asset.get('AS-392-283-000-0');
        final requests = asset.getRequests();
        assertEquals(1, requests.length());
        assertEquals('PR-5852-1608-0000', requests.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAssetRequests'));
        assertEquals(
            ['AS-392-283-000-0'].toString(),
            apiMock.callArgs('getAssetRequests', 0).toString());
    }


    public function testGetRequestsEmpty() {
        // Check subject
        final asset = Model.parse(Asset, '{"id": "AS-XXX-XXX-XXX-X"}');
        final requests = asset.getRequests();
        assertEquals(0, requests.length());

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAssetRequests'));
        assertEquals(
            ['AS-XXX-XXX-XXX-X'].toString(),
            apiMock.callArgs('getAssetRequests', 0).toString());
    }


    public function testGetNewItems() {
        final asset = Asset.get('AS-392-283-000-0');
        final newItems = asset.getNewItems();
        assertEquals(2, newItems.length());
        assertEquals('TEAM_ST3L2T1Y', newItems.get(0).id);
        assertEquals('100', newItems.get(0).quantity);
        assertEquals('0', newItems.get(0).oldQuantity);
        assertEquals('TEAM_ST3L2TAC1M', newItems.get(1).id);
        assertEquals('200', newItems.get(1).quantity);
        assertEquals('0', newItems.get(1).oldQuantity);
    }


    public function testGetChangedItems() {
        final asset = Asset.get('AS-392-283-000-0');
        final changedItems = asset.getChangedItems();
        assertEquals(2, changedItems.length());
        assertEquals('UPSIZE_TEST', changedItems.get(0).id);
        assertEquals('201', changedItems.get(0).quantity);
        assertEquals('200', changedItems.get(0).oldQuantity);
        assertEquals('DOWNSIZE_TEST', changedItems.get(1).id);
        assertEquals('199', changedItems.get(1).quantity);
        assertEquals('200', changedItems.get(1).oldQuantity);
    }


    public function testGetRemovedItems() {
        final asset = Asset.get('AS-392-283-000-0');
        final removedItems = asset.getRemovedItems();
        assertEquals(1, removedItems.length());
        assertEquals('DELETE_TEST', removedItems.get(0).id);
        assertEquals('0', removedItems.get(0).quantity);
        assertEquals('200', removedItems.get(0).oldQuantity);
    }


    public function testGetParamByIdOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final param = asset.getParamById('activationCode');
        assertTrue(Std.is(param, Param));
        assertEquals('activationCode', param.id);
    }


    public function testGetParamByIdKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final param = asset.getParamById('invalid-id');
        assertTrue(param == null);
    }


    public function testGetItemByIdOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemById('TEAM_ST3L2T1Y');
        assertTrue(Std.is(item, Item));
        assertEquals('TEAM_ST3L2T1Y', item.id);
    }


    public function testGetItemByIdKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemById('invalid-id');
        assertTrue(item == null);
    }


    public function testGetItemByMpnOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByMpn('TEAM-ST3L2T1Y');
        assertTrue(Std.is(item, Item));
        assertEquals('TEAM-ST3L2T1Y', item.mpn);
    }


    public function testGetItemByMpnKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByMpn('invalid-mpn');
        assertTrue(item == null);
    }


    public function testGetItemByGlobalIdOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByGlobalId('XXX');
        assertTrue(Std.is(item, Item));
        assertEquals('XXX', item.globalId);
    }


    public function testGetItemByGlobalIdKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByGlobalId('invalid-id');
        assertTrue(item == null);
    }
}
