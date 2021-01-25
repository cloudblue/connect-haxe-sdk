/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Activation;
import connect.models.Events;
import connect.models.Param;
import connect.models.Template;
import connect.models.TierConfig;
import connect.models.TierConfigRequest;
import connect.models.User;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class TierConfigRequestTest {
    @Before
    public function setup() {
        Env._reset(new TierConfigRequestApiClientMock());
    }

    @Test
    public function testList() {
        final requests = TierConfigRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(1, requests.length());
        Assert.isType(requests.get(0), TierConfigRequest);
    }

    @Test
    public function testGetOk() {
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
    }

    @Test
    public function testRegister() {
        final request = new TierConfigRequest().register();
        Assert.isType(request, TierConfigRequest);
    }

    @Test
    public function testUpdate() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.getParamById('param_a').value = 'Hello, world!';
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, TierConfigRequest);
        Assert.areNotEqual(updatedRequest, request);
    }

    @Test
    public function testUpdateNoChanges() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        final updatedRequest = request.update(null);
        Assert.isType(updatedRequest, TierConfigRequest);
        Assert.areEqual(updatedRequest, request);
    }

    @Test
    public function testUpdateWithTcParams() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.configuration.getParamById('tc_param').value = 'New value';
        final updatedRequest = request.update(null);
        Assert.isNotNull(updatedRequest.getParamById('tc_param'));
    }

    @Test
    public function testUpdateWithParams() {
        final param = new Param();
        param.id = 'PM-9861-7949-8492-0001';
        param.valueError = 'Please provide a value.';
        final request = TierConfigRequest.get('TCR-000-000-000');
        final updatedRequest = request.update(new Collection<Param>().push(param));
        Assert.isType(updatedRequest, TierConfigRequest);
        Assert.areEqual(request.toString(), updatedRequest.toString());
    }

    @Test
    public function testUpdateWithEmptyValueError() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.configuration.getParamById('tc_param').valueError = '';
        final updatedRequest = request.update(null);
        Assert.areEqual('tc_param_value', updatedRequest.getParamById('tc_param').value);
        Assert.areEqual('', updatedRequest.getParamById('tc_param').valueError);
    }

    @Test
    public function testUpdateWithValueError() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.configuration.getParamById('tc_param').valueError = 'Changed';
        final updatedRequest = request.update(null);
        Assert.areEqual('tc_param_value', updatedRequest.getParamById('tc_param').value);
        Assert.areEqual('Changed', updatedRequest.getParamById('tc_param').valueError);
    }

    @Test
    public function testUpdateWithNotes() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        request.notes = "Notes text";
        final updatedRequest = request.update(null);
        Assert.isType(request, TierConfigRequest);
    }

    @Test
    public function testApproveByTemplate() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        Assert.isTrue(request.approveByTemplate('TL-XXX-XXX-XXX'));
    }

    @Test
    public function testApproveByTile() {
        final request = TierConfigRequest.get('TCR-000-000-000');
        Assert.isType(request.approveByTile('Hello, world!'), TierConfigRequest);
    }

    @Test
    public function testFail() {
        Assert.isTrue(TierConfigRequest.get('TCR-000-000-000').fail("Failing..."));
    }

    @Test
    public function testInquire() {
        Assert.isTrue(TierConfigRequest.get('TCR-000-000-000').inquire());
    }

    @Test
    public function testPend() {
        Assert.isTrue(TierConfigRequest.get('TCR-000-000-000').pend());
    }

    @Test
    public function testAssign() {
        Assert.isTrue(TierConfigRequest.get('TCR-000-000-000').assign());
    }

    @Test
    public function testUnassign() {
        Assert.isTrue(TierConfigRequest.get('TCR-000-000-000').unassign());
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

class TierConfigRequestApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/tierconfigrequests.json';

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
                case 'https://api.conn.rocks/public/v1/tier/config-requests':
                    return new Response(200, File.getContent(FILE), null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000':
                    final request = Json.parse(File.getContent(FILE))[0];
                    return new Response(200, Json.stringify(request), null);
            }
        case 'POST':
            switch (url) {
                case 'https://api.conn.rocks/public/v1/tier/config-requests':
                    return new Response(200, body, null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000/approve':
                    return new Response(200, body, null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000/fail':
                    return new Response(204, null, null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000/inquire':
                    return new Response(204, null, null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000/pend':
                    return new Response(204, null, null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000/assign':
                    return new Response(204, null, null);
                case 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000/unassign':
                    return new Response(204, null, null);
            }
        case 'PUT':
            if (url == 'https://api.conn.rocks/public/v1/tier/config-requests/TCR-000-000-000') {
                return new Response(200, body, null);
            }
    }
    return new Response(404, null, null);
}
}
