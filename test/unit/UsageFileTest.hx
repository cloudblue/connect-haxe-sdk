/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Account;
import connect.models.Contract;
import connect.models.Marketplace;
import connect.models.Product;
import connect.models.UsageFile;
import connect.models.UsageParam;
import connect.models.UsageRecord;
import connect.models.UsageStats;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class UsageFileTest {
    @Before
    public function setup() {
        Env._reset(new UsageFileApiClientMock());
    }

    @Test
    public function testList() {
        final usageFiles = UsageFile.list(null);
        Assert.isType(usageFiles, Collection);
        Assert.areEqual(1, usageFiles.length());
        Assert.isType(usageFiles.get(0), UsageFile);
        Assert.areEqual('UF-2018-11-9878764342', usageFiles.get(0).id);
    }

    @Test
    public function testGetOk() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        Assert.isType(usageFile, UsageFile);
        Assert.isType(usageFile.product, Product);
        Assert.isType(usageFile.contract, Contract);
        Assert.isType(usageFile.marketplace, Marketplace);
        Assert.isType(usageFile.vendor, Account);
        Assert.isType(usageFile.provider, Account);
        Assert.isType(usageFile.stats, UsageStats);
        Assert.areEqual('UF-2018-11-9878764342', usageFile.id);
        Assert.areEqual('Usage for Feb 2019', usageFile.name);
        Assert.areEqual('This file contains usage for the product belonging to month Feb 2019', usageFile.description);
        Assert.areEqual('My personal note', usageFile.note);
        Assert.areEqual('READY', usageFile.status);
        Assert.areEqual('PA-000-000', usageFile.events.created.by.id);
        Assert.areEqual('Username', usageFile.events.created.by.name);
        Assert.areEqual('2018-11-21T11:10:29+00:00', usageFile.events.created.at.toString());
        Assert.areEqual('<File Location for uploaded file>', usageFile.usageFileUri);
        Assert.areEqual('<File Location for generated file>', usageFile.processedFileUri);
        Assert.areEqual('CN-783-317-575', usageFile.product.id);
        Assert.areEqual('Google Apps', usageFile.product.name);
        Assert.areEqual('/media/VA-587-127/CN-783-317-575/media/CN-783-317-575-logo.png', usageFile.product.icon);
        Assert.areEqual('CRD-00000-00000-00000', usageFile.contract.id);
        Assert.areEqual('ACME Distribution Contract', usageFile.contract.name);
        Assert.areEqual('MP-198987', usageFile.marketplace.id);
        Assert.areEqual('France', usageFile.marketplace.name);
        Assert.areEqual('/media/PA-123-123/marketplaces/MP-12345/image.png', usageFile.marketplace.icon);
        Assert.areEqual('VA-587-127', usageFile.vendor.id);
        Assert.areEqual('Symantec', usageFile.vendor.name);
        Assert.areEqual('PA-587-127', usageFile.provider.id);
        Assert.areEqual('ABC Corp', usageFile.provider.name);
        Assert.areEqual('All usage data is correct', usageFile.acceptanceNote);
        Assert.areEqual('Rejected due to wrong usage for item 56', usageFile.rejectionNote);
        Assert.areEqual('Error details in case of usage file is marked as invalid', usageFile.errorDetail);
        Assert.areEqual(56, usageFile.stats.validated);
        Assert.areEqual(0, usageFile.stats.uploaded);
    }

    @Test
    public function testGetKo() {
        Assert.isNull(UsageFile.get('UF-XXXX-XX-XXXXXXXXXX'));
    }

    @Test
    public function testRegister() {
        Assert.isType(new UsageFile().register(), UsageFile);
    }

    @Test
    public function testUpdate() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        usageFile.note = 'Hello, world!';
        final updatedFile = usageFile.update();
        Assert.isType(updatedFile, UsageFile);
        Assert.areNotEqual(updatedFile, usageFile);
    }

    @Test
    public function testUpdateNoChanges() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final updatedFile = usageFile.update();
        Assert.areEqual(updatedFile, usageFile);
    }

    @Test
    public function testDelete() {
        Assert.isTrue(UsageFile.get('UF-2018-11-9878764342').delete());
    }

    @Test
    public function testUploadRecords() {
    /*
    #if python
        final sheetName = 'test/mocks/data/sheet_py.xlsx';
    #else
        final sheetName = 'test/mocks/data/sheet.xlsx';
    #end
    */

        // Create dates
        final today = DateTime.now();
        final yesterday = new DateTime(
            today.getYear(), today.getMonth(), today.getDay() - 1,
            today.getHours(), today.getMinutes(), today.getSeconds());

        // Create custom param
        final param = new UsageParam();
        param.parameterName = 'v.aobo';
        param.parameterValue = '1';

        // Create record
        final record = new UsageRecord();
        record.recordId = 'Unique record value';
        record.itemSearchCriteria = 'item.mpn';
        record.itemSearchValue = 'SKUA';
        record.amount = 1.5;
        record.quantity = 1;
        record.startTimeUtc = yesterday;
        record.endTimeUtc = today;
        record.assetSearchCriteria = 'parameter.param_b';
        record.assetSearchValue = 'tenant2';
        record.params = new Collection<UsageParam>().push(param);
        final records = new Collection<UsageRecord>().push(record);

        // Check subject
        final usageFile = new UsageFile().register();
        final newFile = usageFile.uploadRecords(records);
        Assert.isType(newFile, UsageFile);
    }

    @Test
    public function testUpload() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.upload(null);
        Assert.areNotEqual(newFile, usageFile);
    }

    @Test
    public function testSubmit() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.submit();
        Assert.areNotEqual(newFile, usageFile);
    }

    @Test
    public function testAccept() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.accept('Accept');
        Assert.areNotEqual(newFile, usageFile);
    }

    @Test
    public function testReject() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.reject('Reject');
        Assert.areNotEqual(newFile, usageFile);
    }

    @Test
    public function testClose() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.close();
        Assert.areNotEqual(newFile, usageFile);
    }

    @Test
    public function testGetTemplate() {
        Assert.isNull(UsageFile.get('UF-2018-11-9878764342').getTemplate());
    }

    @Test
    public function testGetTemplateLink() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final link = usageFile.getTemplateLink();
        Assert.areEqual('https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22', link);
    }

    @Test
    public function testReprocess() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.reprocess();
        Assert.areNotEqual(newFile, usageFile);
    }
}

class UsageFileApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/usagefiles.json';

    public function new() {
    }
    
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
        fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger:Logger,  ?logLevel: Null<Int> = null) : Response {
    switch (method) {
        case 'GET':
            switch (url) {
                case 'https://api.conn.rocks/public/v1/usage/files':
                    return new Response(200, File.getContent(FILE), null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342':
                    final usageFile = Json.parse(File.getContent(FILE))[0];
                    return new Response(200, Json.stringify(usageFile), null);
                case 'https://api.conn.rocks/public/v1/usage/products/UF-2018-11-9878764342/template':
                    return new Response(200, '{"template_link": "https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22"}', null);
            }
        case 'POST':
            switch (url) {
                case 'https://api.conn.rocks/public/v1/usage/files':
                    return new Response(200, body, null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/delete':
                    return new Response(204, null, null);
                case 'https://api.conn.rocks/public/v1/usage/files/upload':
                    return new Response(200, '{}', null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/upload':
                    return new Response(200, '{}', null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/submit':
                    return new Response(200, '{}', null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/accept':
                    return new Response(200, '{}', null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/reject':
                    return new Response(200, '{}', null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/close':
                    return new Response(200, '{}', null);
                case 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342/reprocess':
                    return new Response(200, '{}', null);
            }
        case 'PUT':
            if (url == 'https://api.conn.rocks/public/v1/usage/files/UF-2018-11-9878764342') {
                return new Response(200, body, null);
            }
    }
    return new Response(404, null, null);
}
}
