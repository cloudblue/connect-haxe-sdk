/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Asset;
import connect.models.Param;
import connect.util.Blob;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class ItemTest {
    @Before
    public function setup() {
        Env._reset(new ItemApiClientMock());
    }

    @Test
    public function testGetParamByIdOk() {
        final item = Asset.get('AS-392-283-000-0').items.get(0);
        final param = item.getParamById('item_parameter');
        Assert.isType(param, Param);
        Assert.areEqual('item_parameter', param.id);
        Assert.areEqual('Value 1', param.value);
    }

    @Test
    public function testGetParamByIdKo() {
        final item = Asset.get('AS-392-283-000-0').items.get(0);
        final param = item.getParamById('invalid-id');
        Assert.isNull(param);
    }
}

class ItemApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/requests.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        if (method == 'GET' && url == 'https://api.conn.rocks/public/v1/assets/AS-392-283-000-0') {
            final request = Json.parse(File.getContent(FILE))[0];
            return new Response(200, haxe.Json.stringify(request.asset), null);
        }
        return new Response(404, null, null);
    }
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
