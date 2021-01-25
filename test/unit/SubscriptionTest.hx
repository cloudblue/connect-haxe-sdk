/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Subscription;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class SubscriptionTest {
    @Before
    public function setup() {
        Env._reset(new SubscriptionApiClientMock());
    }

    @Test
    public function testList() {
        final subscriptions = Subscription.list(null);
        Assert.isType(subscriptions, Collection);
        Assert.areEqual(1, subscriptions.length());
        Assert.isType(subscriptions.get(0), Subscription);
        Assert.areEqual('AS-0000-0000-0001', subscriptions.get(0).id);
    }

    @Test
    public function testGetOk() {
        final subscription = Subscription.get('AS-0000-0000-0001');
        Assert.isType(subscription, Subscription);
        Assert.isType(subscription.events, connect.models.Events);
        Assert.isType(subscription.product, connect.models.Product);
        Assert.isType(subscription.connection, connect.models.Connection);
        Assert.isType(subscription.params, Collection);
        Assert.isType(subscription.tiers, connect.models.Tiers);
        Assert.isType(subscription.marketplace, connect.models.Marketplace);
        Assert.isType(subscription.contract, connect.models.Contract);
        Assert.isType(subscription.items, Collection);
        Assert.isType(subscription.billing, connect.models.BillingInfo);
    }

    @Test
    public function testGetKo() {
        final subscription = Subscription.get(null);
        Assert.isNull(subscription);
    }
}

class SubscriptionApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/subscriptions.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/subscriptions/assets':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/subscriptions/assets/AS-0000-0000-0001':
                        final list = Json.parse(File.getContent(FILE));
                        return new Response(200, Json.stringify(list[0]), null);
                }
        }
        return new Response(404, null, null);
    }
    
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
