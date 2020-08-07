/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.models.Subscription;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import sys.io.File;
import test.mocks.Mock;

class SubscriptionTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .set('IApiClient', 'SubscriptionApiClientMock'));
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

class SubscriptionApiClientMock extends Mock implements IApiClient {
    static final FILE = 'test/unit/data/subscriptions.json';

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        this.calledFunction('syncRequest', [method, url, headers, body,
            fileArg, fileName, fileContent, certificate]);
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/subscriptions/assets':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/subscriptions/assets/AS-0000-0000-0001':
                        final list = Mock.parseJsonFile(FILE);
                        return new Response(200, haxe.Json.stringify(list[0]), null);
                }
        }
        return new Response(404, null, null);
    }
}
