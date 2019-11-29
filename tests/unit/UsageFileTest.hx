package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Account;
import connect.models.Contract;
import connect.models.Marketplace;
import connect.models.Product;
import connect.models.UsageFile;
import connect.models.UsageRecord;
import connect.models.UsageRecords;
import tests.mocks.Mock;


class UsageFileTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IUsageApi', 'tests.mocks.UsageApiMock')
            .setString('IApiClient', 'tests.mocks.ApiClientMock'));
    }


    public function testList() {
        // Check subject
        final usageFiles = UsageFile.list(null);
        assertTrue(Std.is(usageFiles, Collection));
        assertEquals(1, usageFiles.length());
        assertTrue(Std.is(usageFiles.get(0), UsageFile));
        assertEquals('UF-2018-11-9878764342', usageFiles.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('listUsageFiles'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listUsageFiles', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        assertTrue(Std.is(usageFile, UsageFile));
        assertTrue(Std.is(usageFile.product, Product));
        assertTrue(Std.is(usageFile.contract, Contract));
        assertTrue(Std.is(usageFile.marketplace, Marketplace));
        assertTrue(Std.is(usageFile.vendor, Account));
        assertTrue(Std.is(usageFile.provider, Account));
        assertTrue(Std.is(usageFile.records, UsageRecords));
        assertEquals('UF-2018-11-9878764342', usageFile.id);
        assertEquals('Usage for Feb 2019', usageFile.name);
        assertEquals('This file contains usage for the product belonging to month Feb 2019', usageFile.description);
        assertEquals('My personal note', usageFile.note);
        assertEquals('READY', usageFile.status);
        assertEquals('rahul.mondal@ingrammicro.com', usageFile.createdBy);
        assertEquals('2018-11-21T11:10:29+00:00', usageFile.createdAt);
        assertEquals('<File Location for uploaded file>', usageFile.uploadFileUri);
        assertEquals('<File Location for generated file>', usageFile.processedFileUri);
        assertEquals('CN-783-317-575', usageFile.product.id);
        assertEquals('Google Apps', usageFile.product.name);
        assertEquals('/media/VA-587-127/CN-783-317-575/media/CN-783-317-575-logo.png', usageFile.product.icon);
        assertEquals('CRD-00000-00000-00000', usageFile.contract.id);
        assertEquals('ACME Distribution Contract', usageFile.contract.name);
        assertEquals('MP-198987', usageFile.marketplace.id);
        assertEquals('France', usageFile.marketplace.name);
        assertEquals('/media/PA-123-123/marketplaces/MP-12345/image.png', usageFile.marketplace.icon);
        assertEquals('VA-587-127', usageFile.vendor.id);
        assertEquals('Symantec', usageFile.vendor.name);
        assertEquals('PA-587-127', usageFile.provider.id);
        assertEquals('ABC Corp', usageFile.provider.name);
        assertEquals('All usage data is correct', usageFile.acceptanceNote);
        assertEquals('Rejected due to wrong usage for item 56', usageFile.rejectionNote);
        assertEquals('Error details in case of usage file is marked as invalid', usageFile.errorDetails);
        assertEquals(56, usageFile.records.valid);
        assertEquals(0, usageFile.records.invalid);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('getUsageFile'));
        assertEquals(
            ['UF-2018-11-9878764342'].toString(),
            apiMock.callArgs('getUsageFile', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final usageFile = UsageFile.get('UF-XXXX-XX-XXXXXXXXXX');
        assertTrue(usageFile == null);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('getUsageFile'));
        assertEquals(
            ['UF-XXXX-XX-XXXXXXXXXX'].toString(),
            apiMock.callArgs('getUsageFile', 0).toString());
    }


    public function testRegister() {
        // Check subject
        final usageFile = new UsageFile().register();
        assertTrue(Std.is(usageFile, UsageFile));
        assertEquals('UF-2018-11-9878764342', usageFile.id);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('createUsageFile'));
        assertEquals(
            [new UsageFile()].toString(),
            apiMock.callArgs('createUsageFile', 0).toString());
    }


    public function testUpdate() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        usageFile.note = 'Hello, world!';
        final updatedFile = usageFile.update();
        assertTrue(Std.is(updatedFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), updatedFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('updateUsageFile'));
        assertEquals(
            [usageFile.id, usageFile.toString()].toString(),
            apiMock.callArgs('updateUsageFile', 0).toString());
    }


    public function testDelete() {
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        usageFile.delete();

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('deleteUsageFile'));
        assertEquals(
            ['UF-2018-11-9878764342'].toString(),
            apiMock.callArgs('deleteUsageFile', 0).toString());
    }


    public function testUploadRecords() {
    /*
    #if python
        final sheetName = 'tests/mocks/data/sheet_py.xlsx';
    #else
        final sheetName = 'tests/mocks/data/sheet.xlsx';
    #end
    */

        // Create dates
        final today = Date.now();
        final yesterday = new Date(
            today.getFullYear(), today.getMonth(), today.getDate() - 1,
            today.getHours(), today.getMinutes(), today.getSeconds());

        // Create record
        final record = new UsageRecord();
        record.recordId = 'Unique record value';
        record.itemSearchCriteria = 'item.mpn';
        record.itemSearchValue = 'SKUA';
        record.quantity = 1;
        record.startTimeUtc = connect.Util.getDate(yesterday);
        record.endTimeUtc = connect.Util.getDate(today);
        record.assetSearchCriteria = 'parameter.param_b';
        record.assetSearchValue = 'tenant2';
        final records = new Collection<UsageRecord>().push(record);

        // Check subject
        final usageFile = new UsageFile().register();
        final newFile = usageFile.uploadRecords(records);
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks (does not work because the generated file always differs in date)
        /*
        final args: Array<Dynamic> = [usageFile.id, Blob.load(sheetName)];
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('uploadUsageFile'));
        assertEquals(
            args.toString(),
            apiMock.callArgs('uploadUsageFile', 0).toString());
        */
    }


    public function testUpload() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.upload(null);
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('uploadUsageFile'));
        assertEquals(
            [usageFile.id, null].toString(),
            apiMock.callArgs('uploadUsageFile', 0).toString());
    }


    public function testSubmit() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.submit();
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('submitUsageFileAction'));
        assertEquals(
            [usageFile.id].toString(),
            apiMock.callArgs('submitUsageFileAction', 0).toString());
    }


    public function testAccept() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.accept('Accept');
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('acceptUsageFileAction'));
        assertEquals(
            [usageFile.id, 'Accept'].toString(),
            apiMock.callArgs('acceptUsageFileAction', 0).toString());
    }


    public function testReject() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.reject('Reject');
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('rejectUsageFileAction'));
        assertEquals(
            [usageFile.id, 'Reject'].toString(),
            apiMock.callArgs('rejectUsageFileAction', 0).toString());
    }


    public function testClose() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.close();
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('closeUsageFileAction'));
        assertEquals(
            [usageFile.id].toString(),
            apiMock.callArgs('closeUsageFileAction', 0).toString());
    }


    public function testGetTemplate() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final template = usageFile.getTemplate();
        assertTrue(template == null);
        //assertTrue(Std.is(template, ByteData));

        // Check mocks
        final apiMock = cast(Env.getApiClient(), Mock);
        assertEquals(1, apiMock.callCount('syncRequest'));
        assertEquals(
            ['GET',
            'https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22',
            null,
            null,
            null,
            null,
            null].toString(),
            apiMock.callArgs('syncRequest', 0).toString());
        final usageMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, usageMock.callCount('getProductSpecificUsageFileTemplate'));
        assertEquals(
            [usageFile.id].toString(),
            usageMock.callArgs('getProductSpecificUsageFileTemplate', 0).toString());
    }


    public function testGetTemplateLink() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final link = usageFile.getTemplateLink();
        assertEquals('https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22', link);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('getProductSpecificUsageFileTemplate'));
        assertEquals(
            [usageFile.id].toString(),
            apiMock.callArgs('getProductSpecificUsageFileTemplate', 0).toString());
    }


    public function testReprocess() {
        // Check subject
        final usageFile = UsageFile.get('UF-2018-11-9878764342');
        final newFile = usageFile.reprocess();
        assertTrue(Std.is(newFile, UsageFile));
        assertEquals(UsageFile.get('UF-2018-11-9878764342').toString(), newFile.toString());
        // ^ The mock returns that file

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('reprocessProcessedFile'));
        assertEquals(
            [usageFile.id].toString(),
            apiMock.callArgs('reprocessProcessedFile', 0).toString());
    }
}
