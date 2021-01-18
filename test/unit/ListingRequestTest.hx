/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Listing;
import connect.models.ListingRequest;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class ListingRequestTest {
    @Before
    public function setup() {
        Env._reset(new ListingRequestApiClientMock());
    }

    @Test
    public function testList() {
        final requests = ListingRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(1, requests.length());
        Assert.isType(requests.get(0), ListingRequest);
        Assert.areEqual('LSTR-409-308-930', requests.get(0).id);
    }

    @Test
    public function testGetOk() {
        final request = ListingRequest.get('LSTR-409-308-930');
        Assert.isType(request, ListingRequest);
        Assert.isNull(request.product);
        Assert.isType(request.listing, Listing);
        Assert.isType(request.created, DateTime);
        Assert.isType(request.updated, DateTime);
        Assert.areEqual('new', request.type);
        Assert.areEqual('draft', request.state);
        Assert.areEqual('LST-086-623-913', request.listing.id);
        Assert.isTrue(request.created.equals(DateTime.fromString('2018-12-12T14:45:14+00:00')));
        Assert.isTrue(request.updated.equals(DateTime.fromString('2018-12-12T14:45:14+00:00')));
    }

    @Test
    public function testGetKo() {
        Assert.isNull(ListingRequest.get('LSTR-XXX-XXX-XXX'));
    }

    @Test
    public function testRegister() {
        final request = new ListingRequest().register();
        Assert.isType(request, ListingRequest);
    }

    @Test
    public function testAssign() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').assign());
    }

    @Test
    public function testUnassign() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').unassign());
    }

    @Test
    public function testChangeToDraft() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').changeToDraft());
    }

    @Test
    public function testChangeToDeploying() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').changeToDeploying());
    }

    @Test
    public function testChangeToCompleted() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').changeToCompleted());
    }

    @Test
    public function testChangeToCanceled() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').changeToCanceled());
    }

    @Test
    public function testChangeToReviewing() {
        Assert.isTrue(ListingRequest.get('LSTR-409-308-930').changeToReviewing());
    }
}

class ListingRequestApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/listingrequests.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/listing-requests':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930':
                        final request = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(request), null);
                }
            case 'POST':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/listing-requests':
                        return new Response(200, body, null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/assign':
                        return new Response(202, '{}', null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/unassign':
                        return new Response(202, '{}', null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/refine':
                        return new Response(202, '{}', null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/deploy':
                        return new Response(202, '{}', null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/complete':
                        return new Response(202, '{}', null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/cancel':
                        return new Response(202, '{}', null);
                    case 'https://api.conn.rocks/public/v1/listing-requests/LSTR-409-308-930/submit':
                        return new Response(202, '{}', null);
                }
        }
        return new Response(404, null, null);
    }
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
