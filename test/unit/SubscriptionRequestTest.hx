/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.SubscriptionRequest;
import connect.models.SubscriptionRequestAttributes;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class SubscriptionRequestTest {
    @Before
    public function setup() {
        Env._reset(new SubscriptionRequestApiClientMock());
    }

    @Test
    public function testList() {
        final requests = SubscriptionRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(1, requests.length());
        Assert.isType(requests.get(0), SubscriptionRequest);
        Assert.areEqual('BRP-0000-0000-0001-0001', requests.get(0).id);
    }

    @Test
    public function testGetOk() {
        final request = SubscriptionRequest.get('BRP-0000-0000-0001-0001');
        Assert.isType(request, SubscriptionRequest);
        Assert.isType(request.events, connect.models.Events);
        Assert.isType(request.asset, connect.models.Subscription);
        Assert.isType(request.items, Collection);
        Assert.isType(request.attributes, SubscriptionRequestAttributes);
        Assert.isType(request.period, connect.models.Period);
    }

    @Test
    public function testGetKo() {
        final request = SubscriptionRequest.get(null);
        Assert.isNull(request);
    }

    @Test
    public function testRegister() {
        final request = new SubscriptionRequest().register();
        Assert.isType(request, SubscriptionRequest);
        Assert.areEqual('BRP-REGISTERED', request.id);
    }

    @Test
    public function testUpdateVendorAttributes() {
        final request = new SubscriptionRequest().register();
        request.type = 'vendor';
        request.attributes = new SubscriptionRequestAttributes();
        request.attributes.vendor = new Dictionary().set('external_id', 'xxx');
        final updated = request.updateAttributes();
        Assert.isTrue(updated);
    }

    @Test
    public function testUpdateProviderAttributes() {
        final request = new SubscriptionRequest().register();
        request.type = 'provider';
        request.attributes = new SubscriptionRequestAttributes();
        request.attributes.provider = new Dictionary().set('external_id', 'xxx');
        final updated = request.updateAttributes();
        Assert.isTrue(updated);
    }

    @Test
    public function testUpdateInvalidAttributes() {
        final request = new SubscriptionRequest().register();
        request.type = 'provider';
        request.attributes = new SubscriptionRequestAttributes();
        request.attributes.vendor = new Dictionary().set('external_id', 'xxx');
        final updated = request.updateAttributes();
        Assert.isFalse(updated);
    }
}

class SubscriptionRequestApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/subscriptionrequests.json';

    public function new() {
    }

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/subscriptions/requests':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/subscriptions/requests/BRP-0000-0000-0001-0001':
                        final list = Json.parse(File.getContent(FILE));
                        return new Response(200, Json.stringify(list[0]), null);
                }
            case 'POST':
                if (url == 'https://api.conn.rocks/public/v1/subscriptions/requests') {
                    return new Response(200, '{"id": "BRP-REGISTERED"}', null);
                }
            case 'PUT':
                if (url == 'https://api.conn.rocks/public/v1/subscriptions/requests/BRP-REGISTERED/attributes') {
                    return new Response(200, body, null);
                }
        }
        return new Response(404, null, null);
    }

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
