/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Activation;
import connect.models.Events;
import connect.models.Param;
import connect.models.Template;
import connect.models.TierConfig;
import connect.models.TierConfigRequest;
import connect.models.User;
import tests.mocks.Mock;


class TierConfigRequestTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('ITierApi', 'tests.mocks.TierApiMock'));
    }


    public function testList() {
        // Check subject
        final requests = TierConfigRequest.list(null);
        assertTrue(Std.is(requests, Collection));
        assertEquals(1, requests.length());
        assertTrue(Std.is(requests.get(0), TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('listTierConfigRequests'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listTierConfigRequests', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        assertTrue(Std.is(request, TierConfigRequest));
        assertTrue(Std.is(request.configuration, TierConfig));
        assertTrue(Std.is(request.params, Collection));
        assertTrue(Std.is(request.assignee, User));
        assertTrue(Std.is(request.template, Template));
        assertTrue(Std.is(request.activation, Activation));
        assertTrue(Std.is(request.events, Events));
        assertEquals('TCR-000-000-000', request.id);
        assertEquals('setup', request.type);
        assertEquals('pending', request.status);
        assertEquals('TC-000-000-000', request.configuration.id);
        assertEquals(1, request.params.length());
        assertEquals('param_a', request.params.get(0).id);
        assertEquals('param_a_value', request.params.get(0).value);
        assertEquals('PA-000-000', request.assignee.id);
        assertEquals('Username', request.assignee.name);
        assertEquals('TP-000-000-000', request.template.id);
        assertEquals('http://example.com', request.activation.link);
        assertEquals('2018-11-21T11:10:29+00:00', request.events.created.at.toString());
        assertEquals('2018-11-21T11:10:29+00:00', request.events.inquired.at.toString());
        assertEquals('PA-000-000', request.events.inquired.by.id);
        assertEquals('Username', request.events.inquired.by.name);
        assertEquals('2018-11-21T11:10:29+00:00', request.events.pended.at.toString());
        assertEquals('PA-000-001', request.events.pended.by.id);
        assertEquals('Username1', request.events.pended.by.name);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('getTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('getTierConfigRequest', 0).toString());
    }


    public function testRegister() {
        // Check subject
        final request = new TierConfigRequest().register();
        assertTrue(Std.is(request, TierConfigRequest));
        assertEquals('TCR-000-000-000', request.id);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('createTierConfigRequest'));
        assertEquals(
            [new TierConfigRequest()].toString(),
            apiMock.callArgs('createTierConfigRequest', 0).toString());
    }


    public function testUpdate() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final updatedRequest = request.update();
        assertTrue(Std.is(updatedRequest, TierConfigRequest));
        assertEquals(TierConfigRequest.get('TCR-000-000-000').toString(),
            updatedRequest.toString());
        // ^ The mock returns that request

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('updateTierConfigRequest'));
        assertEquals(
            [request.id, request.toString()].toString(),
            apiMock.callArgs('updateTierConfigRequest', 0).toString());
    }


    public function testApproveByTemplate() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final approvedRequest = request.approveByTemplate('TL-XXX-XXX-XXX');
        assertTrue(Std.is(approvedRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('approveTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000', '{"template_id":"TL-XXX-XXX-XXX"}'].toString(),
            apiMock.callArgs('approveTierConfigRequest', 0).toString());
    }


    public function testApproveByTile() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final approvedRequest = request.approveByTile('Hello, world!');
        assertTrue(Std.is(approvedRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('approveTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000', '{"activation_tile":"Hello, world!"}'].toString(),
            apiMock.callArgs('approveTierConfigRequest', 0).toString());
    }


    public function testFail() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final failedRequest = request.fail("Failing...");
        assertTrue(Std.is(failedRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('failTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000', '{"reason":"Failing..."}'].toString(),
            apiMock.callArgs('failTierConfigRequest', 0).toString());
    }

    public function testInquire() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final inquiredRequest = request.inquire();
        assertTrue(Std.is(inquiredRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('inquireTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('inquireTierConfigRequest', 0).toString());
    }


    public function testPend() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final pendedRequest = request.pend();
        assertTrue(Std.is(pendedRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('pendTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('pendTierConfigRequest', 0).toString());
    }


    public function testAssign() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final assignedRequest = request.assign();
        assertTrue(Std.is(assignedRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('assignTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('assignTierConfigRequest', 0).toString());
    }


    public function testUnassign() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final unassignedRequest = request.unassign();
        assertTrue(Std.is(unassignedRequest, TierConfigRequest));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('unassignTierConfigRequest'));
        assertEquals(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('unassignTierConfigRequest', 0).toString());
    }


    public function testGetParamByIdOk() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        final param = request.getParamById('param_a');
        assertTrue(Std.is(param, Param));
        assertEquals('param_a', param.id);
        assertEquals('param_a_value', param.value);
    }


    public function testGetParamByIdKo() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        final param = request.getParamById('invalid-id');
        assertTrue(param == null);
    }
}
