package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Account;
import connect.models.Contract;
import connect.models.Marketplace;
import connect.models.Product;
import connect.models.UsageFile;
import connect.models.UsageRecords;
import tests.mocks.Mock;


class UsageFileTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IUsageApi', 'tests.mocks.UsageApiMock'));
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


    public function testCreate() {
        // Check subject
        final usageFile = UsageFile.create(new UsageFile());
        assertTrue(Std.is(usageFile, UsageFile));
        assertEquals('UF-2018-11-9878764342', usageFile.id);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(1, apiMock.callCount('createUsageFile'));
        assertEquals(
            [new UsageFile()].toString(),
            apiMock.callArgs('createUsageFile', 0).toString());
    }


    public function testCreateNull() {
        // Check subject
        final usageFile = UsageFile.create(null);
        assertTrue(usageFile == null);

        // Check mocks
        final apiMock = cast(Env.getUsageApi(), Mock);
        assertEquals(0, apiMock.callCount('createUsageFile'));
    }
}
