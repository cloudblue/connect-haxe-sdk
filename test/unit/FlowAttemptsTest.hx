/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

import connect.Env;
import connect.Flow;
import connect.Processor;
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
import test.mocks.Mock;
import connect.api.Response;
import connect.api.IApiClient;
import connect.api.Query;
import connect.api.Response;
import connect.util.Blob;
import connect.util.Dictionary;
import connect.logger.LoggerHandler;
import connect.logger.LoggerConfig;
import test.util.ArrayLoggerWriter;
import connect.logger.MarkdownLoggerFormatter;
import sys.FileSystem;
import sys.io.File;

class ApiClientFlowAttemptMock extends Mock implements IApiClient {
    private static final REQUESTS_PATH = 'requests';

    public function syncRequest(method:String, url:String, headers:Dictionary, body:String, fileArg:String, fileName:String, fileContent:Blob):Response {
        this.calledFunction('syncRequest', [method, url, headers, body, fileArg, fileName, fileContent]);

        if (StringTools.contains(url, REQUESTS_PATH) && method.toUpperCase() == 'GET') {
            return new Response(200, Mock.parseJsonFile('test/mocks/data/request_list.json'), null);
        }

        if (StringTools.contains(url, REQUESTS_PATH) && method.toUpperCase() == 'PUT') {
            return new Response(404, "No connection with the API", null);
        }

        return new Response(200, '[{"life": "The anwser is 42"}]', null);
    }
}

class TestFlow extends Flow {
    public function new() {
        super(null);
        this.step("test step 1", this.firstStep);
    }

    public function firstStep(f:Flow):Void {
        this.abort();
    }
}

class FlowAttemptsTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary().setString('IApiClient', 'ApiClientFlowAttemptMock'));
        var maskedFields:Collection<String> = new Collection();
        Env.initLogger(new LoggerConfig().handlers(new Collection<LoggerHandler>().push(new LoggerHandler(new MarkdownLoggerFormatter(),
            new ArrayLoggerWriter())))
            .maskedFields(maskedFields));
        Env.initConfig("TESTAPIURL", "TESTAPIKEY", new Collection<String>().push("PRD-TEST-0001"));
        if (!FileSystem.exists("logs")) {
            FileSystem.createDirectory("logs");
        }
        if (FileSystem.exists("logs/step.dat")) {
            FileSystem.deleteFile("logs/step.dat");
        }
    }

    @Test
    public function testAttempts() {
        var testFlow:TestFlow = new TestFlow();
        var request_list = Model.parseArray(AssetRequest, sys.io.File.getContent('test/mocks/data/request_list.json'));
        Assert.areEqual(0, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(1, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(2, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(3, testFlow.getCurrentAttempt());
    }
}
