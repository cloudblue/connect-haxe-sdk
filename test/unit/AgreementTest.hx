/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Account;
import connect.models.Agreement;
import connect.models.AgreementStats;
import connect.models.User;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class AgreementTest {
    @Before
    public function setup() {
        Env._reset(new AgreementApiClientMock());
    }

    @Test
    public function testList() {
        final agreements = Agreement.list(null);
        Assert.isType(agreements, Collection);
        Assert.areEqual(1, agreements.length());
        Assert.isType(agreements.get(0), Agreement);
        Assert.areEqual('AGP-884-348-731', agreements.get(0).id);
    }

    @Test
    public function testGetOk() {
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
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Agreement.get('AGP-XXX-XXX-XXX'));
    }

    @Test
    public function testRegister() {
        final agreement = new Agreement().register();
        Assert.isType(agreement, Agreement);
        Assert.areEqual('AGP-REGISTERED', agreement.id);
    }

    @Test
    public function testUpdate() {
        final agreement = Agreement.get('AGP-884-348-731');
        agreement.title = 'New title';
        final updatedAgreement = agreement.update();
        Assert.areNotEqual(updatedAgreement, agreement);
    }

    @Test
    public function testUpdateSame() {
        final agreement = Agreement.get('AGP-884-348-731');
        final updatedAgreement = agreement.update();
        Assert.areEqual(updatedAgreement, agreement);
    }

    @Test
    public function testRemoveOk() {
        Assert.isTrue(Agreement.get('AGP-884-348-731').remove());
    }

    @Test
    public function testRemoveKo() {
        Assert.isFalse(new Agreement().remove());
    }

    @Test
    public function testListVersions() {
        final versions = Agreement.get('AGP-884-348-731').listVersions();
        Assert.isType(versions, Collection);
        Assert.areEqual(1, versions.length());
        Assert.isType(versions.get(0), Agreement);
        Assert.areEqual('AGP-884-348-731', versions.get(0).id);
    }

    @Test
    public function testRegisterVersionOk() {
        final agreement = Agreement.get('AGP-884-348-731').registerVersion();
        Assert.isType(agreement, Agreement);
    }

    @Test
    public function testRegisterVersionKo() {
        Assert.isNull(new Agreement().registerVersion());
    }

    @Test
    public function testGetVersionOk() {
        final version = Agreement.get('AGP-884-348-731').getVersion(3);
        Assert.isType(version, Agreement);
    }

    @Test
    public function testGetVersionKo() {
        Assert.isNull(new Agreement().getVersion(1));
    }

    @Test
    public function testRemoveVersionOk() {
        Assert.isTrue(Agreement.get('AGP-884-348-731').removeVersion(2));
    }

    @Test
    public function testRemoveVersionKo() {
        Assert.isFalse(Agreement.get('AGP-884-348-731').removeVersion(0));
    }

    @Test
    public function testListSubAgreements() {
        final agreements = Agreement.get('AGP-884-348-731').listSubAgreements();
        Assert.isType(agreements, Collection);
        Assert.areEqual(0, agreements.length());
    }

    @Test
    public function testRegisterSubAgreement() {
        final agreement = Agreement.get('AGP-884-348-731').registerSubAgreement(new Agreement());
        Assert.isType(agreement, Agreement);
    }
}

class AgreementApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/agreements.json';

    public function new() {
    }

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/agreements':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731':
                        final agreement = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(agreement), null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731/versions':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731/version/3':
                        final agreement = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(agreement), null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731/agreements':
                        return new Response(200, '[]', null);
                }
            case 'POST':
                switch (url) {
                    case  'https://api.conn.rocks/public/v1/agreements':
                        return new Response(200, '{"id": "AGP-REGISTERED"}', null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731/versions':
                        return new Response(200, body, null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731/agreements':
                        return new Response(200, body, null);
                }
            case 'PUT':
                if (url == 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731') {
                    return new Response(200, body, null);
                }
            case 'DELETE':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731':
                        return new Response(204, null, null);
                    case 'https://api.conn.rocks/public/v1/agreements/AGP-884-348-731/version/2':
                        return new Response(204, null, null);
                }
        }
        return new Response(404, null, null);
    }
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
