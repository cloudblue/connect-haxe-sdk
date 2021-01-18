/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.api.Query;
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
import connect.models.TierConfig;
import connect.models.Tiers;
import connect.models.User;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class AssetTest {
    @Before
    public function setup() {
        Env._reset(new AssetApiClientMock());
    }

    @Test
    public function testList() {
        final assets = Asset.list(null);
        Assert.isType(assets, Collection);
        Assert.areEqual(2, assets.length());
        final asset0 = assets.get(0);
        Assert.isType(asset0, Asset);
        Assert.areEqual('AS-392-283-000-0', asset0.id);
        final asset1 = assets.get(1);
        Assert.isType(asset1, Asset);
        Assert.areEqual('AS-392-283-001-0', asset1.id);
    }

    @Test
    public function testGetOk() {
        final asset = Asset.get('AS-392-283-000-0');
        Assert.isType(asset, Asset);
        Assert.isType(asset.product, Product);
        Assert.isType(asset.connection, Connection);
        Assert.isType(asset.connection.provider, Account);
        Assert.isType(asset.connection.vendor, Account);
        Assert.isType(asset.contract, Contract);
        Assert.isType(asset.marketplace, Marketplace);
        Assert.isType(asset.params, Collection);
        Assert.areEqual(1, asset.params.length());
        Assert.isType(asset.params.get(0), Param);
        Assert.isType(asset.params.get(0).valueChoices, Collection);
        Assert.areEqual(0, asset.params.get(0).valueChoices.length());
        Assert.isType(asset.tiers, Tiers);
        Assert.isType(asset.tiers.customer, TierAccount);
        Assert.isType(asset.tiers.customer.contactInfo, ContactInfo);
        Assert.isType(asset.tiers.customer.contactInfo.contact, Contact);
        Assert.isType(asset.tiers.customer.contactInfo.contact.phoneNumber, PhoneNumber);
        Assert.isType(asset.tiers.tier1, TierAccount);
        Assert.isType(asset.items, Collection);
        Assert.areEqual(5, asset.items.length());
        Assert.isType(asset.items.get(0), Item);
        Assert.isType(asset.items.get(0).params, Collection);
        Assert.areEqual(3, asset.items.get(0).params.length());
        Assert.isType(asset.items.get(0).params.get(0), Param);
        Assert.isType(asset.items.get(0).params.get(0).constraints, Constraints);
        Assert.isType(asset.items.get(0).params.get(0).events, Events);
        Assert.isType(asset.items.get(0).params.get(0).events.created, Event);
        Assert.isType(asset.items.get(0).params.get(0).events.created.by, User);
        Assert.isType(asset.configuration, Configuration);
        Assert.isType(asset.configuration.params, Collection);
        Assert.areEqual(1, asset.configuration.params.length());
        Assert.isType(asset.configuration.params.get(0), Param);
        Assert.isType(asset.events, Events);
        Assert.isType(asset.events.created, Event);
        Assert.isType(asset.events.updated, Event);
        Assert.isType(asset.events.created.at, DateTime);
        Assert.isType(asset.events.updated.at, DateTime);
        Assert.areEqual('AS-392-283-000-0', asset.id);
        Assert.areEqual('processing', asset.status);
        Assert.areEqual('1001000', asset.externalId);
        Assert.areEqual('f90e2ed2-b267-4831-93e6-a6b06874e000', asset.externalUid);
        Assert.areEqual('Fallball 498c84b1-d53318a6', asset.externalName);
        Assert.areEqual('CN-631-322-000', asset.product.id);
        Assert.areEqual('ProductName', asset.product.name);
        Assert.areEqual('CT-9344-000', asset.connection.id);
        Assert.areEqual('production', asset.connection.type);
        Assert.areEqual('PA-063-000', asset.connection.provider.id);
        Assert.areEqual('Connection name', asset.connection.provider.name);
        Assert.areEqual('VA-691-000', asset.connection.vendor.id);
        Assert.areEqual('Vendor Name', asset.connection.vendor.name);
        Assert.areEqual('CRP-00000-00000-00000', asset.contract.id);
        Assert.areEqual('Contract of Program Agreement', asset.contract.name);
        Assert.areEqual('MP-12345', asset.marketplace.id);
        Assert.areEqual('France and territories', asset.marketplace.name);
        Assert.areEqual('/media/PA-239-689/marketplaces/MP-54865/icon.png', asset.marketplace.icon);
        Assert.areEqual('2018-11-21T11:10:29+00:00', asset.events.created.at.toString());
        Assert.areEqual('2018-11-21T11:10:29+00:00', asset.events.updated.at.toString());
        
        final param = asset.params.get(0);
        Assert.areEqual('activationCode', param.id);
        Assert.areEqual('Activation Code', param.name);
        Assert.areEqual('Activation Code', param.description);
        Assert.areEqual('text', param.type);
        Assert.areEqual('value param', param.value);
        Assert.areEqual('Error', param.valueError);

        final customer = asset.tiers.customer;
        Assert.areEqual('TA-0-7304-8514-7000', customer.id);
        Assert.areEqual('Name', customer.name);
        Assert.areEqual('street A', customer.contactInfo.addressLine1);
        Assert.areEqual('2 2', customer.contactInfo.addressLine2);
        Assert.areEqual('es', customer.contactInfo.country);
        Assert.areEqual('', customer.contactInfo.state);
        Assert.areEqual('Moscow', customer.contactInfo.city);
        Assert.areEqual('08000', customer.contactInfo.postalCode);
        Assert.areEqual('First Name', customer.contactInfo.contact.firstName);
        Assert.areEqual('Last Name', customer.contactInfo.contact.lastName);
        Assert.areEqual('test@email.com', customer.contactInfo.contact.email);
        Assert.areEqual('+7', customer.contactInfo.contact.phoneNumber.countryCode);
        Assert.areEqual('', customer.contactInfo.contact.phoneNumber.areaCode);
        Assert.areEqual('8901298403', customer.contactInfo.contact.phoneNumber.phoneNumber);
        Assert.areEqual('', customer.contactInfo.contact.phoneNumber.extension);
        Assert.areEqual('1001000', customer.externalId);

        final item = asset.items.get(0);
        Assert.areEqual('TEAM_ST3L2T1Y', item.id);
        Assert.areEqual('TEAM-ST3L2T1Y', item.mpn);
        Assert.areEqual('100', item.quantity);
        Assert.areEqual('0', item.oldQuantity);
        Assert.areEqual('XXX', item.globalId);

        final itemParam = item.params.get(0);
        Assert.areEqual('item_parameter', itemParam.id);
        Assert.areEqual('item_parameter', itemParam.description);
        Assert.areEqual('text', itemParam.type);
        Assert.areEqual('Value 1', itemParam.value);
        Assert.areEqual('item_parameter', itemParam.title);
        Assert.areEqual('item', itemParam.scope);
        Assert.areEqual(false, itemParam.constraints.hidden);
        Assert.areEqual(false, itemParam.constraints.required);
        Assert.areEqual(false, itemParam.constraints.unique);
        Assert.areEqual('2019-08-26T10:42:56+00:00', itemParam.events.created.at.toString());
        Assert.areEqual('UR-841-574-187', itemParam.events.created.by.id);
        Assert.areEqual('Marc Serrat', itemParam.events.created.by.name);
        Assert.areEqual('2019-08-27T14:21:23+00:00', itemParam.events.updated.at.toString());
        Assert.areEqual('UR-841-574-187', itemParam.events.updated.by.id);
        Assert.areEqual('Marc Serrat', itemParam.events.updated.by.name);
        Assert.isFalse(itemParam.isCheckboxChecked('checked'));
        Assert.isFalse(item.params.get(1).isCheckboxChecked('checked'));
        Assert.isTrue(item.params.get(2).isCheckboxChecked('checked'));
    }

    @Test
    public function testGetKo() {
        final asset = Asset.get('AS-XXX-XXX-XXX-X');
        Assert.isNull(asset);
    }

    @Test
    public function testGetRequests() {
        final asset = Asset.get('AS-392-283-000-0');
        final requests = asset.getRequests();
        Assert.areEqual(1, requests.length());
        Assert.areEqual('PR-5852-1608-0000', requests.get(0).id);
    }

    @Test
    public function testGetRequestsEmpty() {
        final asset = Model.parse(Asset, '{"id": "AS-XXX-XXX-XXX-X"}');
        final requests = asset.getRequests();
        Assert.areEqual(0, requests.length());
    }

    @Test
    public function testGetNewItems() {
        final asset = Asset.get('AS-392-283-000-0');
        final newItems = asset.getNewItems();
        Assert.areEqual(2, newItems.length());
        Assert.areEqual('TEAM_ST3L2T1Y', newItems.get(0).id);
        Assert.areEqual('100', newItems.get(0).quantity);
        Assert.areEqual('0', newItems.get(0).oldQuantity);
        Assert.areEqual('TEAM_ST3L2TAC1M', newItems.get(1).id);
        Assert.areEqual('200', newItems.get(1).quantity);
        Assert.areEqual('0', newItems.get(1).oldQuantity);
    }

    @Test
    public function testGetChangedItems() {
        final asset = Asset.get('AS-392-283-000-0');
        final changedItems = asset.getChangedItems();
        Assert.areEqual(2, changedItems.length());
        Assert.areEqual('UPSIZE_TEST', changedItems.get(0).id);
        Assert.areEqual('201', changedItems.get(0).quantity);
        Assert.areEqual('200', changedItems.get(0).oldQuantity);
        Assert.areEqual('DOWNSIZE_TEST', changedItems.get(1).id);
        Assert.areEqual('199', changedItems.get(1).quantity);
        Assert.areEqual('200', changedItems.get(1).oldQuantity);
    }

    @Test
    public function testGetRemovedItems() {
        final asset = Asset.get('AS-392-283-000-0');
        final removedItems = asset.getRemovedItems();
        Assert.areEqual(1, removedItems.length());
        Assert.areEqual('DELETE_TEST', removedItems.get(0).id);
        Assert.areEqual('0', removedItems.get(0).quantity);
        Assert.areEqual('200', removedItems.get(0).oldQuantity);
    }

    @Test
    public function testGetParamByIdOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final param = asset.getParamById('activationCode');
        Assert.isType(param, Param);
        Assert.areEqual('activationCode', param.id);
    }

    @Test
    public function testGetParamByIdKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final param = asset.getParamById('invalid-id');
        Assert.isNull(param);
    }

    @Test
    public function testGetItemByIdOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemById('TEAM_ST3L2T1Y');
        Assert.isType(item, Item);
        Assert.areEqual('TEAM_ST3L2T1Y', item.id);
    }

    @Test
    public function testGetItemByIdKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemById('invalid-id');
        Assert.isNull(item);
    }

    @Test
    public function testGetItemByMpnOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByMpn('TEAM-ST3L2T1Y');
        Assert.isType(item, Item);
        Assert.areEqual('TEAM-ST3L2T1Y', item.mpn);
    }

    @Test
    public function testGetItemByMpnKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByMpn('invalid-mpn');
        Assert.isNull(item);
    }


    @Test
    public function testGetItemByGlobalIdOk() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByGlobalId('XXX');
        Assert.isType(item, Item);
        Assert.areEqual('XXX', item.globalId);
    }


    @Test
    public function testGetItemByGlobalIdKo() {
        final asset = Asset.get('AS-392-283-000-0');
        final item = asset.getItemByGlobalId('invalid-id');
        Assert.isNull(item);
    }

    @Test
    public function testGetCustomerConfig() {
        final asset = Asset.get('AS-392-283-000-0');
        final tierConfig = asset.getCustomerConfig();
        Assert.isType(tierConfig, TierConfig);
    }

    @Test
    public function testGetTier1Config() {
        final asset = Asset.get('AS-392-283-000-0');
        final tierConfig = asset.getTier1Config();
        Assert.isType(tierConfig, TierConfig);
    }

    @Test
    public function testGetTier2Config() {
        final asset = Asset.get('AS-392-283-000-0');
        final tierConfig = asset.getTier2Config();
        Assert.isNull(tierConfig);
    }
}

class AssetApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/requests.json';
    static final TIERCONFIGS_FILE = 'test/unit/data/tierconfigs.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        if (method == 'GET') {
            switch (url) {
                case 'https://api.conn.rocks/public/v1/assets':
                    return new Response(200, Json.stringify(getAssets()), null);
                case 'https://api.conn.rocks/public/v1/assets/AS-392-283-000-0':
                    return new Response(200, Json.stringify(getAssets()[0]), null);
                case 'https://api.conn.rocks/public/v1/assets/AS-392-283-000-0/requests':
                    final requests = Json.parse(File.getContent(FILE)).filter(r -> r.asset.id == 'AS-392-283-000-0');
                    return new Response(200, Json.stringify(requests), null);
                case 'https://api.conn.rocks/public/v1/assets/AS-XXX-XXX-XXX-X/requests':
                    return new Response(200, '[]', null);
                case 'https://api.conn.rocks/public/v1/tier/configs?eq(account.id,TA-0-7304-8514-7000)&eq(product.id,CN-631-322-000)&eq(tier_level,0)':
                    return new Response(200, File.getContent(TIERCONFIGS_FILE), null);
                case 'https://api.conn.rocks/public/v1/tier/configs?eq(account.id,TA-0-7042-5000-3000)&eq(product.id,CN-631-322-000)&eq(tier_level,1)':
                    return new Response(200, File.getContent(TIERCONFIGS_FILE), null);
            }
        }
        return new Response(404, null, null);
    }

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }

    private static function getAssets(): Array<Dynamic> {
        return Json.parse(File.getContent(FILE)).map(r -> r.asset);
    }
}
