/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.models.Asset;
import connect.models.Param;
import connect.util.Blob;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;

class ConfigurationTest {
    @Before
    public function setup() {
        Env._reset(new ConfigurationApiClientMock());
    }

    @Test
    public function testGetParamByIdOk() {
        final config = Asset.get('AS-392-283-000-0').configuration;
        final param = config.getParamById('configParamId');
        Assert.isType(param, Param);
        Assert.areEqual('configParamId', param.id);
    }

    @Test
    public function testGetParamByIdKo() {
        final config = Asset.get('AS-392-283-000-0').configuration;
        final param = config.getParamById('invalid-id');
        Assert.isNull(param);
    }
}

class ConfigurationApiClientMock extends Mock implements IApiClient {
    static final REQUESTS_FILE = 'test/unit/data/requests.json';

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        this.calledFunction('syncRequest', [method, url, headers, body,
            fileArg, fileName, fileContent, certificate]);
        if (method == 'GET' && url == 'https://api.conn.rocks/public/v1/assets/AS-392-283-000-0') {
            final asset = Mock.parseJsonFile(REQUESTS_FILE)[0].asset;
            return new Response(200, haxe.Json.stringify(asset), null);
        }
        return new Response(404, null, null);
    }
}
