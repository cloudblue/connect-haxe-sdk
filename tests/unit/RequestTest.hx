package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Asset;
import connect.models.Contract;
import connect.models.Conversation;
import connect.models.Marketplace;
import connect.models.Model;
import connect.models.Param;
import connect.models.Request;
import tests.mocks.Mock;


class RequestTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'tests.mocks.FulfillmentApiMock')
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        var requests = Request.list(null);
        assertTrue(Std.is(requests, Collection));
        assertEquals(2, requests.length());
        assertTrue(Std.is(requests.get(0), Request));
        assertEquals('PR-5852-1608-0000', requests.get(0).id);
        assertEquals('PR-5852-1608-0001', requests.get(1).id);
        assertEquals('ApiKey XXX', requests.get(0).assignee);
        assertEquals(haxe.Json.stringify({id: 'XXX'}), requests.get(1).assignee);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('listRequests'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listRequests', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        assertTrue(Std.is(request, Request));
        assertTrue(Std.is(request.asset, Asset));
        assertTrue(Std.is(request.contract, Contract));
        assertTrue(Std.is(request.marketplace, Marketplace));
        assertEquals('PR-5852-1608-0000', request.id);
        assertEquals('purchase', request.type);
        assertEquals('2019-02-19T19:23:07.209244+00:00', request.created);
        assertEquals('2019-02-19T19:28:11.053922+00:00', request.updated);
        assertEquals('approved', request.status);
        assertEquals('###tile', request.activationKey);
        assertEquals('', request.reason);
        assertEquals('CRD-00000-00000-00000', request.contract.id);
        assertEquals('ACME Distribution Contract', request.contract.name);
        assertEquals('MP-77000', request.marketplace.id);
        assertEquals('MP Spain', request.marketplace.name);
        assertEquals('/media/PA-063-000/marketplaces/MP-77000/icon.svg', request.marketplace.icon);
        assertEquals('ApiKey XXX', request.assignee);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getRequest'));
        assertEquals(
            ['PR-5852-1608-0000'].toString(),
            apiMock.callArgs('getRequest', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        var request = Request.get('PR-XXXX-XXXX-XXXX');
        assertTrue(request == null);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getRequest'));
        assertEquals(
            ['PR-XXXX-XXXX-XXXX'].toString(),
            apiMock.callArgs('getRequest', 0).toString());
    }


    public function testCreate() {
        // Check subject
        var request = Request.create(new Request());
        assertTrue(Std.is(request, Request));
        assertEquals('PR-5852-1608-0000', request.id);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('createRequest'));
        assertEquals(
            [new Request()].toString(),
            apiMock.callArgs('createRequest', 0).toString());
    }


    public function testCreateNull() {
        // Check subject
        var request = Request.create(null);
        assertTrue(request == null);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(0, apiMock.callCount('createRequest'));
    }


    public function testUpdate() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        request.note = 'Hello, world!';
        var updatedRequest = request.update();
        assertTrue(Std.is(updatedRequest, Request));
        assertEquals(Request.get('PR-5852-1608-0000').toString(), updatedRequest.toString());
        // ^ The mock returns that request

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('updateRequest'));
        assertEquals(
            [request.id, request.toString()].toString(),
            apiMock.callArgs('updateRequest', 0).toString());
    }


    public function testApproveByTemplate() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var approvedRequest = request.approveByTemplate('TL-XXX-XXX-XXX');
        assertTrue(Std.is(approvedRequest, Request));

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('changeRequestStatus'));
        assertEquals(
            ['PR-5852-1608-0000', 'approve', '{"template_id":"TL-XXX-XXX-XXX"}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    public function testApproveByTile() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var approvedRequest = request.approveByTile('Hello, world!');
        assertTrue(Std.is(approvedRequest, Request));

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('changeRequestStatus'));
        assertEquals(
            ['PR-5852-1608-0000', 'approve', '{"activation_tile":"Hello, world!"}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    public function testFail() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var failedRequest = request.fail("Failing...");
        assertTrue(Std.is(failedRequest, Request));

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('changeRequestStatus'));
        assertEquals(
            ['PR-5852-1608-0000', 'fail', '{"reason":"Failing..."}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    public function testInquire() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var inquiredRequest = request.inquire();
        assertTrue(Std.is(inquiredRequest, Request));

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('changeRequestStatus'));
        assertEquals(
            ['PR-5852-1608-0000', 'inquire', '{}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    public function testPend() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var pendedRequest = request.pend();
        assertTrue(Std.is(pendedRequest, Request));

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('changeRequestStatus'));
        assertEquals(
            ['PR-5852-1608-0000', 'pend', '{}'].toString(),
            apiMock.callArgs('changeRequestStatus', 0).toString());
    }


    public function testAssign() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var assignedRequest = request.assign('XXX');
        assertTrue(Std.is(assignedRequest, Request));
        assertEquals('XXX', assignedRequest.assignee);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('assignRequest'));
        assertEquals(
            ['PR-5852-1608-0000', 'XXX'].toString(),
            apiMock.callArgs('assignRequest', 0).toString());
    }


    public function testNeedsMigrationFalse() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        assertFalse(request.needsMigration());
    }


    public function testNeedsMigrationFalse2() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        request.asset.params.push(Model.parse(Param, {
            id: 'migration_info',
            value: ''
        }));
        assertFalse(request.needsMigration());
    }


    public function testNeedsMigrationTrue() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        request.asset.params.push(Model.parse(Param, {
            id: 'migration_info',
            value: '{}'
        }));
        assertTrue(request.needsMigration());
    }


    public function testGetConversation() {
        // Check subject
        var request = Request.get('PR-5852-1608-0000');
        var conv = request.getConversation();
        assertTrue(Std.is(conv, Conversation));
        assertEquals('PR-5852-1608-0000', conv.instanceId);

        // Check mocks
        var apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listConversations'));
        assertEquals(
            ['?instance_id=PR-5852-1608-0000'].toString(),
            apiMock.callArgs('listConversations', 0).toString());
    }
}
