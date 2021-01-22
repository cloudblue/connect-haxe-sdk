/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.models.TierAccount;
import connect.models.Tiers;
import connect.models.Product;
import connect.models.Hub;
import connect.models.Account;
import connect.models.Connection;
import connect.logger.LoggerConfig;
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Asset;
import connect.models.AssetRequest;
import connect.models.Contract;
import connect.models.Conversation;
import connect.models.Marketplace;
import connect.models.Model;
import connect.models.Param;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class AssetRequestTest {
    @Before
    public function setup() {
        Env._reset(new AssetRequestApiClientMock());
    }

    @Test
    public function testList() {
        final requests = AssetRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(2, requests.length());
        Assert.isType(requests.get(0), AssetRequest);
        Assert.areEqual('PR-5852-1608-0000', requests.get(0).id);
        Assert.areEqual('PR-5852-1608-0001', requests.get(1).id);
        Assert.areEqual('ApiKey XXX', requests.get(0).assignee);
        Assert.areEqual(Json.stringify({id: 'XXX'}), requests.get(1).assignee);
    }

    @Test
    public function testGetOk() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        Assert.isType(request, AssetRequest);
        Assert.isType(request.asset, Asset);
        Assert.isType(request.contract, Contract);
        Assert.isType(request.marketplace, Marketplace);
        Assert.areEqual('PR-5852-1608-0000', request.id);
        Assert.areEqual('purchase', request.type);
        Assert.areEqual('2019-02-19T19:23:07+00:00', request.created.toString());
        Assert.areEqual('2019-02-19T19:28:11+00:00', request.updated.toString());
        Assert.areEqual('approved', request.status);
        Assert.areEqual('###tile', request.activationKey);
        Assert.areEqual('', request.reason);
        Assert.areEqual('CRD-00000-00000-00000', request.contract.id);
        Assert.areEqual('ACME Distribution Contract', request.contract.name);
        Assert.areEqual('MP-77000', request.marketplace.id);
        Assert.areEqual('MP Spain', request.marketplace.name);
        Assert.areEqual('/media/PA-063-000/marketplaces/MP-77000/icon.svg', request.marketplace.icon);
        Assert.areEqual('ApiKey XXX', request.assignee);
    }

    @Test
    public function testGetKo() {
        Assert.isNull(AssetRequest.get('PR-XXXX-XXXX-XXXX'));
    }

    @Test
    public function testRegister() {
        final request = new AssetRequest().register();
        Assert.isType(request, AssetRequest);
    }

    @Test
    public function testUpdate() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.note = 'Hello, world!';
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, AssetRequest);
        Assert.areNotEqual(updatedRequest, request);
    }

    @Test
    public function testUpdateNoChanges() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, AssetRequest);
        Assert.areEqual(updatedRequest, request);
    }

    @Test
    public function testUpdateWithParams() {
        final param = new Param();
        param.id = 'PM-9861-7949-8492-0001';
        param.valueError = 'Please provide a value.';
        final request = AssetRequest.get('PR-5852-1608-0000');
        final updatedRequest = request.update(new Collection<Param>().push(param));
        Assert.isType(updatedRequest, AssetRequest);
        Assert.areEqual(request, updatedRequest);
    }

    @Test
    public function testUpdateWithEmptyValueError() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final param = request.asset.getParamById('activationCode');
        param.valueError = '';
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, AssetRequest);
        Assert.areNotEqual(updatedRequest, request);
        Assert.areEqual('value param', updatedRequest.asset.getParamById('activationCode').value);
        Assert.areEqual('', updatedRequest.asset.getParamById('activationCode').valueError);
    }

    @Test
    public function testUpdateWithValueError() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final param = request.asset.getParamById('activationCode');
        param.valueError = 'Changed';
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, AssetRequest);
        Assert.areNotEqual(updatedRequest, request);
        Assert.areEqual('value param', updatedRequest.asset.getParamById('activationCode').value);
        Assert.areEqual('Changed', updatedRequest.asset.getParamById('activationCode').valueError);
    }

    @Test
    public function testUpdateWithNote() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.note = "Note text.";
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, AssetRequest);
    }

    @Test
    public function testApproveByTemplate() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final approvedRequest = request.approveByTemplate('TL-XXX-XXX-XXX');
        Assert.isType(approvedRequest, AssetRequest);
    }

    @Test
    public function testApproveByTile() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final approvedRequest = request.approveByTile('Hello, world!');
        Assert.isType(approvedRequest, AssetRequest);
    }

    @Test
    public function testFail() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final failedRequest = request.fail("Failing...");
        Assert.isType(failedRequest, AssetRequest);
    }

    @Test
    public function testInquire() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final inquiredRequest = request.inquire(null);
        Assert.isType(inquiredRequest, AssetRequest);
    }

    @Test
    public function testInquireWithTemplate() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final inquiredRequest = request.inquire("TL-000");
        Assert.isType(inquiredRequest, AssetRequest);
    }

    @Test
    public function testPend() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final pendedRequest = request.pend();
        Assert.isType(pendedRequest, AssetRequest);
    }

    @Test
    public function testAssign() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        final assignedRequest = request.assign('XXX');
        Assert.isType(assignedRequest, AssetRequest);
        Assert.areEqual('XXX', assignedRequest.assignee);
    }

    @Test
    public function testNeedsMigrationFalse() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        Assert.isFalse(request.needsMigration());
    }

    @Test
    public function testNeedsMigrationFalse2() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.asset.params.push(Model.parse(Param, '{"id": "migration_info", "value": ""}'));
        Assert.isFalse(request.needsMigration());
    }

    @Test
    public function testNeedsMigrationTrue() {
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.asset.params.push(Model.parse(Param, '{"id": "migration_info", "value": "..."}'));
        Assert.isTrue(request.needsMigration());
    }

    @Test
    public function testGetConversation() {
        final request = new AssetRequest();
        request.id = 'PR-5852-1608-0001';
        request.asset = new Asset();
        request.asset.connection = new Connection();
        request.asset.connection.provider = new Account();
        request.asset.connection.provider.id = "PROVIDER";
        request.asset.connection.hub = new Hub();
        request.asset.connection.hub.id = "HUB";
        request.marketplace = new Marketplace();
        request.marketplace.id = "MKP";
        request.asset.product = new Product();
        request.asset.product.id = "PRODUCT";
        request.asset.tiers = new Tiers();
        request.asset.tiers.customer = new TierAccount();
        request.asset.tiers.customer.id = "CUSTOMER";
        Env.initLogger(new LoggerConfig());
        final conv = request.getConversation();
        Assert.isType(conv, Conversation);
        Assert.areEqual('PR-5852-1608-0000', conv.instanceId);
    }
}

class AssetRequestApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/requests.json';
    static final CONVERSATIONS_FILE = 'test/unit/data/conversations.json';

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
                case 'https://api.conn.rocks/public/v1/requests':
                    return new Response(200, File.getContent(FILE), null);
                case 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000':
                    final list = Json.parse(File.getContent(FILE));
                    return new Response(200, Json.stringify(list[0]), null);
                case 'https://api.conn.rocks/public/v1/conversations?instance_id=PR-5852-1608-0000':
                    return new Response(200, '[]', null);
                case 'https://api.conn.rocks/public/v1/conversations?instance_id=PR-5852-1608-0001':
                    return new Response(200, File.getContent(CONVERSATIONS_FILE), null);
                case 'https://api.conn.rocks/public/v1/conversations/CO-000-000-000':
                    final conv = Json.parse(File.getContent(CONVERSATIONS_FILE))[0];
                    return new Response(200, Json.stringify(conv), null);
            }
        case 'POST':
            switch (url) {
                case 'https://api.conn.rocks/public/v1/requests':
                    return new Response(200, body, null);
                case 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000/approve':
                    final request = Json.parse(File.getContent(FILE))[0];
                    request.status = 'approved';
                    return new Response(200, Json.stringify(request), null);
                case 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000/fail':
                    final request = Json.parse(File.getContent(FILE))[0];
                    request.status = 'failed';
                    return new Response(200, Json.stringify(request), null);
                case 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000/inquire':
                    final request = Json.parse(File.getContent(FILE))[0];
                    request.status = 'inquired';
                    return new Response(200, Json.stringify(request), null);
                case 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000/pend':
                    final request = Json.parse(File.getContent(FILE))[0];
                    request.status = 'pending';
                    return new Response(200, Json.stringify(request), null);
                case 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000/assign/XXX':
                    final request = Json.parse(File.getContent(FILE))[0];
                    request.assignee = 'XXX';
                    return new Response(200, Json.stringify(request), null);
            }
        case 'PUT':
            if (url == 'https://api.conn.rocks/public/v1/requests/PR-5852-1608-0000') {
                return new Response(200, body, null);
            }
    }
    return new Response(404, null, null);
}
}
