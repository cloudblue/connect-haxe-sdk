/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
import connect.models.Activation;
import connect.models.Events;
import connect.models.Param;
import connect.models.Template;
import connect.models.TierConfig;
import connect.models.TierConfigRequest;
import connect.models.User;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class TierConfigRequestTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('ITierApi', 'test.mocks.TierApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final requests = TierConfigRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(1, requests.length());
        Assert.isType(requests.get(0), TierConfigRequest);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listTierConfigRequests'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listTierConfigRequests', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        Assert.isType(request, TierConfigRequest);
        Assert.isType(request.configuration, TierConfig);
        Assert.isType(request.params, Collection);
        Assert.isType(request.assignee, User);
        Assert.isType(request.template, Template);
        Assert.isType(request.activation, Activation);
        Assert.isType(request.events, Events);
        Assert.areEqual('TCR-000-000-000', request.id);
        Assert.areEqual('setup', request.type);
        Assert.areEqual('pending', request.status);
        Assert.areEqual('TC-000-000-000', request.configuration.id);
        Assert.areEqual(1, request.params.length());
        Assert.areEqual('param_a', request.params.get(0).id);
        Assert.areEqual('param_a_value', request.params.get(0).value);
        Assert.areEqual('PA-000-000', request.assignee.id);
        Assert.areEqual('Username', request.assignee.name);
        Assert.areEqual('TP-000-000-000', request.template.id);
        Assert.areEqual('http://example.com', request.activation.link);
        Assert.areEqual('2018-11-21T11:10:29+00:00', request.events.created.at.toString());
        Assert.areEqual('2018-11-21T11:10:29+00:00', request.events.inquired.at.toString());
        Assert.areEqual('PA-000-000', request.events.inquired.by.id);
        Assert.areEqual('Username', request.events.inquired.by.name);
        Assert.areEqual('2018-11-21T11:10:29+00:00', request.events.pended.at.toString());
        Assert.areEqual('PA-000-001', request.events.pended.by.id);
        Assert.areEqual('Username1', request.events.pended.by.name);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('getTierConfigRequest', 0).toString());
    }


    @Test
    public function testRegister() {
        // Check subject
        final request = new TierConfigRequest().register();
        Assert.isType(request, TierConfigRequest);
        Assert.areEqual('TCR-000-000-000', request.id);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createTierConfigRequest'));
        Assert.areEqual(
            [new TierConfigRequest()].toString(),
            apiMock.callArgs('createTierConfigRequest', 0).toString());
    }


    @Test
    public function testUpdate() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.getParamById('param_a').value = 'Hello, world!';
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, TierConfigRequest);
        Assert.areEqual(TierConfigRequest.get('TCR-000-000-000').toString(),
            updatedRequest.toString());
        // ^ The mock returns that request

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateTierConfigRequest'));
        Assert.areEqual(
            [request.id, request._toDiffString()].toString(),
            apiMock.callArgs('updateTierConfigRequest', 0).toString());
    }


    @Test
    public function testUpdateNoChanges() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, TierConfigRequest);
        Assert.areEqual(request.toString(), updatedRequest.toString());

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(0, apiMock.callCount('updateTierConfigRequest'));
    }


    @Test
    public function testUpdateWithTcParams() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.configuration.getParamById('tc_param').value = 'New value';
        request.update(null);
        request.params = request.configuration.params;
        Reflect.deleteField(request, 'configuration');

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateTierConfigRequest'));
        Assert.areEqual(
            [request.id, request._toDiffString()].toString(),
            apiMock.callArgs('updateTierConfigRequest', 0).toString());
    }


    @Test
    public function testUpdateWithParams() {
        // Check subject
        final param = new Param();
        param.id = 'PM-9861-7949-8492-0001';
        param.valueError = 'Please provide a value.';
        final request = TierConfigRequest.get('TCR-000-000-000');
        final updatedRequest = request.update(new Collection<Param>().push(param));
        Assert.isType(updatedRequest, TierConfigRequest);
        Assert.areEqual(request.toString(), updatedRequest.toString());

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateTierConfigRequest'));
        final callArgs = apiMock.callArgs('updateTierConfigRequest', 0);
        Assert.areEqual(
            [request.id, '{"params":[{"id":"PM-9861-7949-8492-0001","value_error":"Please provide a value."}]}'].toString(),
            [callArgs[0], Helper.sortStringObject(TierConfigRequest, callArgs[1])].toString());
    }


    @Test
    public function testApproveByTemplate() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.approveByTemplate('TL-XXX-XXX-XXX');

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('approveTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000', '{"template_id":"TL-XXX-XXX-XXX"}'].toString(),
            apiMock.callArgs('approveTierConfigRequest', 0).toString());
    }


    @Test
    public function testApproveByTile() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.approveByTile('Hello, world!');

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('approveTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000', '{"activation_tile":"Hello, world!"}'].toString(),
            apiMock.callArgs('approveTierConfigRequest', 0).toString());
    }


    @Test
    public function testFail() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.fail("Failing...");

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('failTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000', '{"reason":"Failing..."}'].toString(),
            apiMock.callArgs('failTierConfigRequest', 0).toString());
    }

    
    @Test
    public function testInquire() {
        // Check subject
        TierConfigRequest.get('TCR-000-000-000').inquire();

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('inquireTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('inquireTierConfigRequest', 0).toString());
    }


    @Test
    public function testPend() {
        // Check subject
        TierConfigRequest.get('TCR-000-000-000').pend();

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('pendTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('pendTierConfigRequest', 0).toString());
    }


    @Test
    public function testAssign() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.assign();

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('assignTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('assignTierConfigRequest', 0).toString());
    }


    @Test
    public function testUnassign() {
        // Check subject
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.unassign();

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('unassignTierConfigRequest'));
        Assert.areEqual(
            ['TCR-000-000-000'].toString(),
            apiMock.callArgs('unassignTierConfigRequest', 0).toString());
    }


    @Test
    public function testGetParamByIdOk() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        final param = request.getParamById('param_a');
        Assert.isType(param, Param);
        Assert.areEqual('param_a', param.id);
        Assert.areEqual('param_a_value', param.value);
    }


    @Test
    public function testGetParamByIdKo() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        final param = request.getParamById('invalid-id');
        Assert.isNull(param);
    }
}
