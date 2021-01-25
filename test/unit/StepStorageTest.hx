/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
import connect.logger.LoggerConfig;
import connect.models.AssetRequest;
import connect.models.Constraints;
import connect.models.Item;
import connect.models.Param;
import connect.storage.StepData;
import connect.storage.StepStorage;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.FileSystem;

class StepStorageTest {
    @Before
    public function setup() {
        Env._reset();
        Env.initLogger(new LoggerConfig());
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
        Env._reset();
        Env.initLogger(new LoggerConfig().path('custom'));
        Assert.areEqual('custom/step.dat', StepStorage.getStepFilename());
    }
  
    @Test
    public function testLocalSaveAndLoadItem() {
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
        final loadedItem = loadedData.data.get('item');

        Assert.isTrue(Std.is(loadedItem, Item));
        Assert.areEqual(1, loadedItem.params.length());
        Assert.isTrue(Std.is(loadedItem.params.get(0), Param));
        final expected = Json.stringify(Helper.sortObject(item.toObject()));
        final actual = Json.stringify(Helper.sortObject(loadedItem.toObject()));
        Assert.areEqual(expected, actual);
    }
   
    @Test
    public function testLocalSaveAndLoadDictionary() {
        final dict = new Dictionary()
            .set('id', '12345')
            .set('name', 'Unnamed');
        final request = new AssetRequest();
        request.id = 'PR-1234';
        final stepData = new StepData(0, new Dictionary().set('dict', dict), LocalStorage, 0);

        StepStorage.save(request, stepData, null, null);
        final loadedData = StepStorage.load(request.id, null);
        final loadedDict = loadedData.data.get('dict');

        Assert.isTrue(Std.is(loadedDict, Dictionary));
    }
 
    @Test
    public function testLocalSaveAndLoadDictionaryWithItem() {
        final param = new Param();
        param.id = '123123123';
        param.name = 'Test_param';
        param.value = '16ec0f63';
        
        final item = new Item();
        item.id = 'SkuB';
        item.mpn = 'Test_mpn';
        item.quantity = '1';
        item.params = new Collection<Param>().push(param);

        final dict = new Dictionary().set('item', item);
        
        final request = new AssetRequest();
        request.id = 'PR-1234';
        
        final stepData = new StepData(0, new Dictionary().set('dict', dict), LocalStorage, 0);
        
        StepStorage.save(request, stepData, null, null);
        final loadedData = StepStorage.load(request.id, null);
        final loadedDict = loadedData.data.get('dict');
        final loadedItem = loadedDict.get('item');

        Assert.isTrue(Std.is(loadedItem, Item));
        Assert.areEqual(1, loadedItem.params.length());
        Assert.isTrue(Std.is(loadedItem.params.get(0), Param));
        final expected = Json.stringify(Helper.sortObject(item.toObject()));
        final actual = Json.stringify(Helper.sortObject(loadedItem.toObject()));
        Assert.areEqual(expected, actual);
    }
}