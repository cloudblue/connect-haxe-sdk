/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.models.Account;
import connect.models.Agreement;
import connect.models.AgreementStats;
import connect.models.User;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import massive.munit.Assert;
import sys.io.File;
import test.mocks.Mock;

class AgreementTest {
    @Before
    public function setup() {
        Env._reset(new AgreementApiClient());
    }

    @Test
    public function testList() {
        final agreements = Agreement.list(null);
        Assert.isType(agreements, Collection);
        Assert.areEqual(1, agreements.length());
        Assert.isType(agreements.get(0), Agreement);
        Assert.areEqual('AGP-884-348-731', agreements.get(0).id);
    }

    /*
    @Test
    public function testGetOk() {
        // Check subject
        final agreement = Agreement.get('AGP-884-348-731');
        Assert.isType(agreement, Agreement);
        Assert.isType(agreement.owner, Account);
        Assert.isType(agreement.stats, AgreementStats);
        Assert.isType(agreement.author, User);
        Assert.areEqual('program', agreement.type);
        Assert.areEqual('Connect Labs Provider Vendor Program', agreement.title);
        Assert.areEqual('Sell your products through the Connect Labs Cloud Marketplace!', agreement.description);
        Assert.isTrue(agreement.created.equals(DateTime.fromString('2018-12-28T18:05:13+00:00')));
        Assert.isTrue(agreement.updated.equals(DateTime.fromString('2019-04-30T18:22:00+00:00')));
        Assert.areEqual('PA-080-719', agreement.owner.id);
        Assert.areEqual('Connect Labs Provider', agreement.owner.name);
        Assert.areEqual(18, agreement.stats.contracts);
        Assert.areEqual(3, agreement.stats.versions);
        Assert.areEqual('UR-953-538-822', agreement.author.id);
        Assert.areEqual('Beolars Bribbs', agreement.author.name);
        Assert.areEqual(3, agreement.version);
        Assert.isTrue(agreement.active);
        Assert.areEqual('https://example.com/incom/distribution/4', agreement.link);
        Assert.isTrue(agreement.versionCreated.equals(DateTime.fromString('2019-01-29T00:06:42+00:00')));
        Assert.areEqual(6, agreement.versionContracts);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getAgreement'));
        Assert.areEqual(
            ['AGP-884-348-731'].toString(),
            apiMock.callArgs('getAgreement', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final agreement = Agreement.get('AGP-XXX-XXX-XXX');
        Assert.isNull(agreement);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getAgreement'));
        Assert.areEqual(
            ['AGP-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getAgreement', 0).toString());
    }


    @Test
    public function testRegister() {
        // Check subject
        final agreement = new Agreement().register();
        Assert.isType(agreement, Agreement);
        Assert.areEqual('AGP-884-348-731', agreement.id);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createAgreement'));
        Assert.areEqual(
            [new Agreement()].toString(),
            apiMock.callArgs('createAgreement', 0).toString());
    }


    @Test
    public function testUpdate() {
        // Check subject
        final agreement = Agreement.get('AGP-884-348-731');
        agreement.title = 'New title';
        final updatedAgreement = agreement.update();
        Assert.isType(updatedAgreement, Agreement);
        Assert.areEqual(Agreement.get('AGP-884-348-731').toString(), updatedAgreement.toString());
        // ^ The mock returns that request

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('updateAgreement'));
        Assert.areEqual(
            [agreement.id, agreement._toDiffString()].toString(),
            apiMock.callArgs('updateAgreement', 0).toString());
    }


    @Test
    public function testUpdateNoChanges() {
        // Check subject
        final agreement = Agreement.get('AGP-884-348-731');
        final updatedAgreement = agreement.update();
        Assert.isType(updatedAgreement, Agreement);
        Assert.areEqual(agreement.toString(), updatedAgreement.toString());

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(0, apiMock.callCount('updateAgreement'));
    }


    @Test
    public function testRemove() {
        // Check subject
        Agreement.get('AGP-884-348-731').remove();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('removeAgreement'));
        Assert.areEqual(
            ['AGP-884-348-731'].toString(),
            apiMock.callArgs('removeAgreement', 0).toString());
    }


    @Test
    public function testListVersions() {
        // Check subject
        final versions = Agreement.get('AGP-884-348-731').listVersions();
        Assert.isType(versions, Collection);
        Assert.areEqual(1, versions.length());
        Assert.isType(versions.get(0), Agreement);
        Assert.areEqual('AGP-884-348-731', versions.get(0).id);

        // Check mock
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listAgreementVersions'));
        Assert.areEqual(
            ['AGP-884-348-731'].toString(),
            apiMock.callArgs('listAgreementVersions', 0).toString());
    }


    @Test
    public function testRegisterVersion() {
        // Check subject
        final agreement = Agreement.get('AGP-884-348-731');
        agreement.registerVersion();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('newAgreementVersion'));
        Assert.areEqual(
            ['AGP-884-348-731', agreement.toString()].toString(),
            apiMock.callArgs('newAgreementVersion', 0).toString());
    }


    @Test
    public function testGetVersion() {
        // Check subject
        final version = Agreement.get('AGP-884-348-731').getVersion(3);
        Assert.isType(version, Agreement);
        Assert.areEqual('AGP-884-348-731', version.id);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getAgreementVersion'));
        Assert.areEqual(
            Std.string(['AGP-884-348-731', 3]),
            Std.string(apiMock.callArgs('getAgreementVersion', 0)));
    }


    @Test
    public function testRemoveVersion() {
        // Check subject
        Agreement.get('AGP-884-348-731').removeVersion(2);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('removeAgreementVersion'));
        Assert.areEqual(
            Std.string(['AGP-884-348-731', 2]),
            Std.string(apiMock.callArgs('removeAgreementVersion', 0)));
    }


    @Test
    public function testListSubAgreements() {
        // Check subject
        final agreements = Agreement.get('AGP-884-348-731').listSubAgreements();
        Assert.isType(agreements, Collection);
        Assert.areEqual(0, agreements.length());

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listAgreementSubAgreements'));
        Assert.areEqual(
            ['AGP-884-348-731'].toString(),
            apiMock.callArgs('listAgreementSubAgreements', 0).toString());
    }


    @Test
    public function testRegisterSubAgreement() {
        // Check subject
        final agreement = Agreement.get('AGP-884-348-731').registerSubAgreement(new Agreement());
        Assert.isType(agreement, Agreement);
        Assert.areEqual('AGP-884-348-731', agreement.id);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createAgreementSubAgreement'));
        Assert.areEqual(
            Std.string(['AGP-884-348-731', new Agreement()]),
            Std.string(apiMock.callArgs('createAgreementSubAgreement', 0)));
    }
    */
}

class AgreementApiClient extends Mock implements IApiClient {
    static final FILE = 'test/unit/data/agreements.json';

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        this.calledFunction('syncRequest', [method, url, headers, body,
            fileArg, fileName, fileContent, certificate]);
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/agreements':
                        return new Response(200, File.getContent(FILE), null);
                }
        }
        return new Response(404, null, null);
    }
}
