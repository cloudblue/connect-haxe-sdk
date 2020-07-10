/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
import connect.models.Account;
import connect.models.Contract;
import connect.models.Marketplace;
import connect.models.Product;
import connect.models.UsageFile;
import connect.models.UsageRecord;
import connect.models.UsageStats;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class UsageFileTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IUsageApi', 'test.mocks.UsageApiMock')
            .setString('IApiClient', 'test.mocks.ApiClientMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final usageFiles = UsageFile.list(null);
        Assert.isType(usageFiles, Collection);
        Assert.areEqual(1, usageFiles.length());
        Assert.isType(usageFiles.get(0), UsageFile);
        Assert.areEqual('UF-2018-11-9878764342', usageFiles.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listUsageFiles'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listUsageFiles', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
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

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getUsageFile'));
        Assert.areEqual(
            ['UF-2018-11-9878764342'].toString(),
            apiMock.callArgs('getUsageFile', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final usageFile = UsageFile.get('UF-XXXX-XX-XXXXXXXXXX');
        Assert.isNull(usageFile);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getUsageFile'));
        Assert.areEqual(
            ['UF-XXXX-XX-XXXXXXXXXX'].toString(),
            apiMock.callArgs('getUsageFile', 0).toString());
    }


    @Test
    public function testRegister() {
        // Check subject
        final usageFile = new UsageFile().register();
        Assert.isType(usageFile, UsageFile);
        Assert.areEqual('UF-2018-11-9878764342', usageFile.id);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createUsageFile'));
        Assert.areEqual(
            [new UsageFile()].toString(),
            apiMock.callArgs('createUsageFile', 0).toString());
    }


    @Test
    public function testUpdate() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        usageFile.note = 'Hello, world!';
        final updatedFile = usageFile.update();
        Assert.isType(updatedFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), updatedFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateUsageFile'));
        Assert.areEqual(
            [usageFile.id, usageFile._toDiffString()].toString(),
            apiMock.callArgs('updateUsageFile', 0).toString());
    }


    @Test
    public function testUpdateNoChanges() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final updatedFile = usageFile.update();
        Assert.isType(updatedFile, UsageFile);
        Assert.areEqual(usageFile.toString(), updatedFile.toString());

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(0, apiMock.callCount('updateUsageFile'));
    }


    @Test
    public function testDelete() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        usageFile.delete();

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('deleteUsageFile'));
        Assert.areEqual(
            ['UF-2018-11-9878764342'].toString(),
            apiMock.callArgs('deleteUsageFile', 0).toString());
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
        final records = new Collection<UsageRecord>().push(record);

        // Check subject
        final usageFile = new UsageFile().register();
        final newFile = usageFile.uploadRecords(records);
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks (does not work because the generated file always differs in date)
        /*
        final args: Array<Dynamic> = [usageFile.id, Blob.load(sheetName)];
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('uploadUsageFile'));
        Assert.areEqual(
            args.toString(),
            apiMock.callArgs('uploadUsageFile', 0).toString());
        */
    }


    @Test
    public function testUpload() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.upload(null);
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('uploadUsageFile'));
        Assert.areEqual(
            [usageFile.id, null].toString(),
            apiMock.callArgs('uploadUsageFile', 0).toString());
    }


    @Test
    public function testSubmit() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.submit();
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('submitUsageFileAction'));
        Assert.areEqual(
            [usageFile.id].toString(),
            apiMock.callArgs('submitUsageFileAction', 0).toString());
    }


    @Test
    public function testAccept() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.accept('Accept');
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('acceptUsageFileAction'));
        Assert.areEqual(
            [usageFile.id, 'Accept'].toString(),
            apiMock.callArgs('acceptUsageFileAction', 0).toString());
    }


    @Test
    public function testReject() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.reject('Reject');
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('rejectUsageFileAction'));
        Assert.areEqual(
            [usageFile.id, 'Reject'].toString(),
            apiMock.callArgs('rejectUsageFileAction', 0).toString());
    }


    @Test
    public function testClose() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.close();
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('closeUsageFileAction'));
        Assert.areEqual(
            [usageFile.id].toString(),
            apiMock.callArgs('closeUsageFileAction', 0).toString());
    }


    @Test
    public function testGetTemplate() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final template = usageFile.getTemplate();
        Assert.isNull(template);
        //Assert.isType(template, ByteData);

        // Check mocks
        final apiMock = cast(Env.getApiClient(), Mock);
        Assert.areEqual(1, apiMock.callCount('syncRequest'));
        Assert.areEqual(
            ['GET',
            'https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22',
            null,
            null,
            null,
            null,
            null,
            null].toString(),
            apiMock.callArgs('syncRequest', 0).toString());
        final usageMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, usageMock.callCount('getProductSpecificUsageFileTemplate'));
        Assert.areEqual(
            [usageFile.id].toString(),
            usageMock.callArgs('getProductSpecificUsageFileTemplate', 0).toString());
    }


    @Test
    public function testGetTemplateLink() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final link = usageFile.getTemplateLink();
        Assert.areEqual('https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22', link);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getProductSpecificUsageFileTemplate'));
        Assert.areEqual(
            [usageFile.id].toString(),
            apiMock.callArgs('getProductSpecificUsageFileTemplate', 0).toString());
    }


    @Test
    public function testReprocess() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.reprocess();
        Assert.isType(newFile, UsageFile);
        Assert.areEqual(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('reprocessProcessedFile'));
        Assert.areEqual(
            [usageFile.id].toString(),
            apiMock.callArgs('reprocessProcessedFile', 0).toString());
    }
}
