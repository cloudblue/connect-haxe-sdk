/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.Flow;
import connect.logger.LoggerConfig;
import connect.logger.MarkdownLoggerFormatter;
import connect.models.AssetRequest;
import connect.models.TierConfigRequest;
import connect.models.Listing;
import connect.models.UsageFile;
import connect.models.Model;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import connect.logger.LoggerHandler;
import haxe.Json;
import massive.munit.Assert;
import sys.FileSystem;
import sys.io.File;
import test.util.ArrayLoggerWriter;

class FlowTest {
    private static final request_list:Collection<AssetRequest> = Model.parseArray(AssetRequest, sys.io.File.getContent('test/unit/data/requests.json'));
    private static final tier_list:Collection<TierConfigRequest> = Model.parseArray(TierConfigRequest,
        sys.io.File.getContent('test/unit/data/tierconfigrequests.json'));
    private static final listing_list:Collection<Listing> = Model.parseArray(Listing, sys.io.File.getContent('test/unit/data/listings.json'));
    private static final usage_list:Collection<UsageFile> = Model.parseArray(UsageFile, sys.io.File.getContent('test/unit/data/usagefiles.json'));

    @Before
    public function setup() {
        Env._reset(new FlowApiClientMock());
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
    public function testFlowRunApprove() {
        final flow = new Flow(null)
            .step('Add dummy data', f -> {})
            .step('Trace request data', f -> {});
        this.flowRunner(flow);
    }

    @Test
    public function testFlowRunInquire() {
        final flow = new Flow(null)
            .step('Add dummy data', f -> f.inquire('TMPL-0001', null))
            .step('Trace request data', f -> {});
        this.flowRunner(flow);
    }

    @Test
    public function testFlowRunFail() {
        final flow = new Flow(null)
            .step('Add dummy data', f -> f.fail('Fail by default'))
            .step('Trace request data', f -> {});
        this.flowRunner(flow);
    }

    @Test
    public function testFlowRunPend() {
        final flow = new Flow(null)
            .step('Add dummy data', f -> f.pend())
            .step('Trace request data', f -> {});
        this.flowRunner(flow);
    }

    @Test
    public function testFlowData() {
        var param = "";
        final flow = new Flow(null)
            .step('Add dummy data', f -> f.setData("TEST_PARAM", "TEST"))
            .step('Trace request data', f -> param = f.getData("TEST_PARAM"));
        this.flowRunner(flow);
        Assert.areEqual("TEST", param);
    }

    @Test
    public function testFlowApproveByTile() {
        final flow = new Flow(null).step('Add dummy data', f -> f.approveByTile("TL-00001"));
        this.flowRunner(flow);
    }

    @Test
    public function testFlowApproveByTemplate() {
        final flow = new Flow(null).step('Add dummy data', f -> f.approveByTemplate("TPL-00001"));
        this.flowRunner(flow);
    }

    @Test
    public function testGetModels() {
        final flow = new Flow(null).step('Add dummy data', f -> {});
        flow._run(request_list);
        Assert.isType(flow.getAssetRequest(), AssetRequest);
        flow._run(tier_list);
        Assert.isType(flow.getTierConfigRequest(), TierConfigRequest);
        flow._run(usage_list);
        Assert.isType(flow.getUsageFile(), UsageFile);
        flow._run(listing_list);
        Assert.isType(flow.getListing(), Listing);
    }
    
    private function flowRunner(flow:Flow) {
        try {
            flow._run(request_list);
            flow._run(tier_list);
            flow._run(listing_list);
            flow._run(usage_list);
        } catch (ex:Dynamic) {
            Assert.fail("Process fail");
        }
    }
}

class FlowApiClientMock implements IApiClient {
    private static final REQUESTS_PATH = 'requests';

    public function new() {
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
    
    public function syncRequest(method:String, url:String, headers:Dictionary, body:String, fileArg:String, fileName:String, fileContent:Blob, certificate:String,  ?logLevel: Null<Int> = null):Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null),logLevel);
    }
}
