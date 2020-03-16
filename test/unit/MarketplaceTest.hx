/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import haxe.DynamicAccess;
import connect.Env;
import connect.models.Account;
import connect.models.Country;
import connect.models.ExtIdHub;
import connect.models.Hub;
import connect.models.Marketplace;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class MarketplaceTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IMarketplaceApi', 'test.mocks.MarketplaceApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final marketplaces = Marketplace.list(null);
        Assert.isType(marketplaces, Collection);
        Assert.areEqual(2, marketplaces.length());
        Assert.isType(marketplaces.get(0), Marketplace);
        Assert.isType(marketplaces.get(1), Marketplace);
        Assert.areEqual('MP-12345', marketplaces.get(0).id);
        Assert.areEqual('MP-54321', marketplaces.get(1).id);

        // Check mock
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listMarketplaces'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listMarketplaces', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
        final marketplace = Marketplace.get('MP-12345');
        Assert.isType(marketplace, Marketplace);
        Assert.isType(marketplace.owner, Account);
        Assert.isType(marketplace.hubs, Collection);
        Assert.isType(marketplace.countries, Collection);
        Assert.areEqual('France and territories', marketplace.name);
        Assert.areEqual('Use the marketplace to distribute services in France and it\'s territories.', marketplace.description);
        Assert.areEqual(34, marketplace.activeContracts);
        Assert.areEqual('/media/PA-123-123/marketplaces/MP-12345/image.png', marketplace.icon);
        Assert.areEqual('PA-123-123', marketplace.owner.id);
        Assert.areEqual('Awesome Provider', marketplace.owner.name);
        Assert.areEqual(2, marketplace.hubs.length());
        Assert.isType(marketplace.hubs.get(0), ExtIdHub);
        Assert.isType(marketplace.hubs.get(0).hub, Hub);
        Assert.areEqual('HB-1234-1234', marketplace.hubs.get(0).hub.id);
        Assert.areEqual('Staging OA 7.4', marketplace.hubs.get(0).hub.name);
        Assert.areEqual('20190101', marketplace.hubs.get(0).externalId);
        Assert.areEqual(1, marketplace.countries.length());
        Assert.isType(marketplace.countries.get(0), Country);
        Assert.areEqual('IN', marketplace.countries.get(0).id);
        Assert.areEqual('India', marketplace.countries.get(0).name);
        Assert.areEqual('/media/countries/india.png', marketplace.countries.get(0).icon);
        Assert.areEqual('Asia', marketplace.countries.get(0).zone);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getMarketplace'));
        Assert.areEqual(
            ['MP-12345'].toString(),
            apiMock.callArgs('getMarketplace', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final marketplace = Marketplace.get('MP-XXXXX');
        Assert.isNull(marketplace);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getMarketplace'));
        Assert.areEqual(
            ['MP-XXXXX'].toString(),
            apiMock.callArgs('getMarketplace', 0).toString());
    }


    @Test
    public function testRegister() {
        // Check subject
        final marketplace = new Marketplace().register();
        Assert.isType(marketplace, Marketplace);
        Assert.areEqual('MP-12345', marketplace.id);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createMarketplace'));
        Assert.areEqual(
            [new Marketplace()].toString(),
            apiMock.callArgs('createMarketplace', 0).toString());
    }


    @Test
    public function testUpdate() {
        // Check subject
        final marketplace = Marketplace.get('MP-12345');
        marketplace.zone = 'US';
        final updatedMarketplace = marketplace.update();
        Assert.isType(updatedMarketplace, Marketplace);
        Assert.areEqual(Marketplace.get('MP-12345').toString(), updatedMarketplace.toString());
        // ^ The mock returns that request

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateMarketplace'));
        Assert.areEqual(
            [marketplace.id, marketplace._toDiff().toString()].toString(),
            apiMock.callArgs('updateMarketplace', 0).toString());
    }


    @Test
    public function testSetIcon() {
        // Check subject
        Marketplace.get('MP-12345').setIcon(Blob.load(null));

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('setMarketplaceIcon'));
        Assert.areEqual(
            Std.string(['MP-12345', Blob.load(null)]),
            Std.string(apiMock.callArgs('setMarketplaceIcon', 0)));
    }


    @Test
    public function testRemove() {
        // Check subject
        Marketplace.get('MP-12345').remove();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('deleteMarketplace'));
        Assert.areEqual(
            Std.string(['MP-12345']),
            Std.string(apiMock.callArgs('deleteMarketplace', 0)));
    }
}
