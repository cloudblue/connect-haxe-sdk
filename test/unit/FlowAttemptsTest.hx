/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.Flow;
import connect.logger.LoggerHandler;
import connect.logger.LoggerConfig;
import connect.logger.MarkdownLoggerFormatter;
import connect.models.AssetRequest;
import connect.models.Model;
import connect.util.Collection;
import connect.util.Blob;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.FileSystem;
import sys.io.File;
import test.util.ArrayLoggerWriter;

class FlowAttemptsTest {
    @Before
    public function setup() {
        Env._reset(new FlowAttemptsApiClientMock());
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
        var request_list = Model.parseArray(AssetRequest, sys.io.File.getContent('test/unit/data/requests.json'));
        Assert.areEqual(0, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(1, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(2, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(3, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(1, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(2, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(3, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(1, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(2, testFlow.getCurrentAttempt());
        testFlow._run(request_list);
        Assert.areEqual(3, testFlow.getCurrentAttempt());
    }
}

class FlowAttemptsApiClientMock implements IApiClient {
    private static final REQUESTS_PATH = 'requests';

    public function new() {
    }    

    public function syncRequest(method:String, url:String, headers:Dictionary, body:String, fileArg:String, fileName:String, fileContent:Blob, certificate:String, ?logLevel: Null<Int> = null):Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }

    public function syncRequestWithLogger(method:String, url:String, headers:Dictionary, body:String, fileArg:String, fileName:String, fileContent:Blob, certificate:String, logger: Logger,  ?logLevel: Null<Int> = null):Response {
        if (StringTools.contains(url, REQUESTS_PATH) && method.toUpperCase() == 'GET') {
            return new Response(200, Json.parse(File.getContent('test/mocks/data/request_list.json')), null);
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
        this.step("test step 1", TestFlow.functionality);
        this.step("test step 2", TestFlow.functionality);
        this.step("test step 3", TestFlow.functionality);
    }

    public static function functionality(f:Flow):Void {
        if (f.getCurrentAttempt() < 4) {
            f.skip();
        }
    }
}
