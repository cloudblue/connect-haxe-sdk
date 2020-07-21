/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.logger.LoggerConfig;
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.models.AssetRequest;
import connect.models.Constraints;
import connect.models.Item;
import connect.models.Param;
import connect.storage.StepData;
import connect.storage.StepStorage;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import sys.FileSystem;


class StepStorageTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary().set('IApiClient', 'test.ApiClientMock'));
    }

    @After
    public function teardown() {
        final filename = StepStorage.getStepFilename();
        if (FileSystem.exists(filename) && !FileSystem.isDirectory(filename)) {
            FileSystem.deleteFile(filename);
        }
    }

    @Test
    public function testGetStepFilename() {
        Assert.areEqual('logs/step.dat', StepStorage.getStepFilename());
    }

    @Test
    public function testGetStepFilenameWithCustomLogPath() {
        Env.initLogger(new LoggerConfig().path('custom'));
        Assert.areEqual('custom/step.dat', StepStorage.getStepFilename());
    }

    @Test
    public function testSaveAndLoadItem() {
        final constraints = new Constraints();
        constraints.required = true;
        
        final param = new Param();
        param.id = '123123123';
        param.name = 'Test_param';
        param.value = '16ec0f63';
        param.constraints = constraints;
        
        final item = new Item();
        item.id = 'SkuB';
        item.mpn = 'Test_mpn';
        item.quantity = '1';
        item.params = new Collection<Param>().push(param);
        
        final request = new AssetRequest();
        request.id = 'PR-1234';
        
        final stepData = new StepData(0, new Dictionary().set('item', item), LocalStorage, 0);
        
        StepStorage.save(request, stepData, null, null);
        final loadedData = StepStorage.load(request.id, null);

        Assert.areEqual(Std.string(stepData), Std.string(loadedData));
    }
}


class ApiClientMock implements IApiClient {
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        trace('Mock called');
        return null;
    }
}
