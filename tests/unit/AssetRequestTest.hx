/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Env;
import connect.models.Asset;
import connect.models.AssetRequest;
import connect.models.Contract;
import connect.models.Conversation;
import connect.models.Marketplace;
import connect.models.Model;
import connect.models.Param;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import tests.mocks.Mock;


class AssetRequestTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'tests.mocks.FulfillmentApiMock')
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final requests = AssetRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(2, requests.length());
        Assert.isType(requests.get(0), AssetRequest);
        Assert.areEqual('PR-5852-1608-0000', requests.get(0).id);
        Assert.areEqual('PR-5852-1608-0001', requests.get(1).id);
        Assert.areEqual('ApiKey XXX', requests.get(0).assignee);
        Assert.areEqual(haxe.Json.stringify({id: 'XXX'}), requests.get(1).assignee);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listRequests'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listRequests', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
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

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getRequest'));
        Assert.areEqual(
            ['PR-5852-1608-0000'].toString(),
            apiMock.callArgs('getRequest', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final request = AssetRequest.get('PR-XXXX-XXXX-XXXX');
        Assert.isNull(request);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getRequest'));
        Assert.areEqual(
            ['PR-XXXX-XXXX-XXXX'].toString(),
            apiMock.callArgs('getRequest', 0).toString());
    }


    @Test
    public function testRegister() {
        // Check subject
        final request = new AssetRequest().register();
        Assert.isType(request, AssetRequest);
        Assert.areEqual('PR-5852-1608-0000', request.id);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createRequest'));
        Assert.areEqual(
            [new AssetRequest()].toString(),
            apiMock.callArgs('createRequest', 0).toString());
    }


    @Test
    public function testUpdate() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.note = 'Hello, world!';
        final updatedRequest = request.update();
        Assert.isType(updatedRequest, AssetRequest);
        Assert.areEqual(AssetRequest.get('PR-5852-1608-0000').toString(), updatedRequest.toString());
        // ^ The mock returns that request

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateRequest'));
        Assert.areEqual(
            [request.id, request.toString()].toString(),
            apiMock.callArgs('updateRequest', 0).toString());
    }


    @Test
    public function testApproveByTemplate() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final approvedRequest = request.approveByTemplate('TL-XXX-XXX-XXX');
        Assert.isType(approvedRequest, AssetRequest);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeRequestStatus'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'approve', '{"template_id":"TL-XXX-XXX-XXX"}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    @Test
    public function testApproveByTile() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final approvedRequest = request.approveByTile('Hello, world!');
        Assert.isType(approvedRequest, AssetRequest);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeRequestStatus'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'approve', '{"activation_tile":"Hello, world!"}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    @Test
    public function testFail() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final failedRequest = request.fail("Failing...");
        Assert.isType(failedRequest, AssetRequest);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeRequestStatus'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'fail', '{"reason":"Failing..."}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    @Test
    public function testInquire() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final inquiredRequest = request.inquire(null);
        Assert.isType(inquiredRequest, AssetRequest);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeRequestStatus'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'inquire', '{}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    @Test
    public function testInquireWithTemplate() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final inquiredRequest = request.inquire("TL-000");
        Assert.isType(inquiredRequest, AssetRequest);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeRequestStatus'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'inquire', '{"template_id":"TL-000"}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    @Test
    public function testPend() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final pendedRequest = request.pend();
        Assert.isType(pendedRequest, AssetRequest);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeRequestStatus'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'pend', '{}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    @Test
    public function testAssign() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final assignedRequest = request.assign('XXX');
        Assert.isType(assignedRequest, AssetRequest);
        Assert.areEqual('XXX', assignedRequest.assignee);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('assignRequest'));
        Assert.areEqual(
            ['PR-5852-1608-0000', 'XXX'].toString(),
            apiMock.callArgs('assignRequest', 0).toString());
    }


    @Test
    public function testNeedsMigrationFalse() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        Assert.isFalse(request.needsMigration());
    }


    @Test
    public function testNeedsMigrationFalse2() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.asset.params.push(Model.parse(Param, '{"id": "migration_info", "value": ""}'));
        Assert.isFalse(request.needsMigration());
    }


    @Test
    public function testNeedsMigrationTrue() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        request.asset.params.push(Model.parse(Param, '{"id": "migration_info", "value": "..."}'));
        Assert.isTrue(request.needsMigration());
    }


    @Test
    public function testGetConversation() {
        // Check subject
        final request = AssetRequest.get('PR-5852-1608-0000');
        final conv = request.getConversation();
        Assert.isType(conv, Conversation);
        Assert.areEqual('PR-5852-1608-0000', conv.instanceId);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listConversations'));
        Assert.areEqual(
            ['?eq(instance_id,PR-5852-1608-0000)'].toString(),
            apiMock.callArgs('listConversations', 0).toString());
    }
}
