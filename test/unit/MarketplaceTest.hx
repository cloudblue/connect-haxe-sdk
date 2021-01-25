/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Account;
import connect.models.Country;
import connect.models.ExtIdHub;
import connect.models.Hub;
import connect.models.Marketplace;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import haxe.Json;
import sys.io.File;

class MarketplaceTest {
    @Before
    public function setup() {
        Env._reset(new MarketplaceApiClientMock());
    }

    @Test
    public function testList() {
        final marketplaces = Marketplace.list(null);
        Assert.isType(marketplaces, Collection);
        Assert.areEqual(2, marketplaces.length());
        Assert.isType(marketplaces.get(0), Marketplace);
        Assert.isType(marketplaces.get(1), Marketplace);
        Assert.areEqual('MP-12345', marketplaces.get(0).id);
        Assert.areEqual('MP-54321', marketplaces.get(1).id);
    }

    @Test
    public function testGetOk() {
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
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Marketplace.get('MP-XXXXX'));
    }

    @Test
    public function testRegister() {
        Assert.isType(new Marketplace().register(), Marketplace);
    }

    @Test
    public function testUpdate() {
        final marketplace = Marketplace.get('MP-12345');
        marketplace.zone = 'US';
        final updatedMarketplace = marketplace.update();
        Assert.isType(updatedMarketplace, Marketplace);
        Assert.areNotEqual(updatedMarketplace, marketplace);
    }

    @Test
    public function testUpdateNoChanges() {
        final marketplace = Marketplace.get('MP-12345');
        final updatedMarketplace = marketplace.update();
        Assert.isType(updatedMarketplace, Marketplace);
        Assert.areEqual(updatedMarketplace, marketplace);
    }

    @Test
    public function testSetIcon() {
        Assert.isTrue(Marketplace.get('MP-12345').setIcon(Blob.load(null)));
    }

    @Test
    public function testRemove() {
        Assert.isTrue(Marketplace.get('MP-12345').remove());
    }
}

class MarketplaceApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/marketplaces.json';

    public function new() {
    }

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/marketplaces':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/marketplaces/MP-12345':
                        final marketplace = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(marketplace), null);
                }
            case 'POST':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/marketplaces':
                        return new Response(200, body, null);
                    case 'https://api.conn.rocks/public/v1/marketplaces/MP-12345/icon':
                        return new Response(200, null, null);
                }
            case 'PUT':
                if (url == 'https://api.conn.rocks/public/v1/marketplaces/MP-12345') {
                    return new Response(200, body, null);
                }
            case 'DELETE':
                if (url == 'https://api.conn.rocks/public/v1/marketplaces/MP-12345') {
                    return new Response(204, null, null);
                }
    }
    return new Response(404, null, null);
}
}
