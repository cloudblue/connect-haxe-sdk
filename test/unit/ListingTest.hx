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
import connect.models.Product;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;


class ListingTest {
    @Before
    public function setup() {
        Env._reset(new ListingApiClientMock());
    }

    @Test
    public function testList() {
        final listings = Listing.list(null);
        Assert.isType(listings, Collection);
        Assert.areEqual(1, listings.length());
        Assert.isType(listings.get(0), Listing);
        Assert.areEqual('LST-212-458-762', listings.get(0).id);
    }

    @Test
    public function testGetOk() {
        final listing = Listing.get('LST-212-458-762');
        Assert.isType(listing, Listing);
        Assert.isType(listing.product, Product);
        Assert.isType(listing.created, DateTime);
        Assert.isType(listing.pendingRequest, ListingRequest);
        Assert.areEqual('unlisted', listing.status);
        Assert.areEqual('CRD-93991-27147-93443', listing.contract.id);
        Assert.areEqual('CN-436-803-738', listing.product.id);
        Assert.areEqual('Sample App', listing.product.name);
        Assert.isTrue(listing.created.equals(DateTime.fromString('2018-12-12T14:40:44+00:00')));
        Assert.areEqual('LSTR-086-623-913-001', listing.pendingRequest.id);
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Listing.get('LST-XXX-XXX-XXX'));
    }

    @Test
    public function testPut() {
        final listing = Listing.get('LST-212-458-762');
        listing.status = 'listed';
        final updatedListing = listing.put();
        Assert.isType(updatedListing, Listing);
        Assert.areNotEqual(updatedListing, listing);
    }

    @Test
    public function testPutNoChanges() {
        final listing = Listing.get('LST-212-458-762');
        final updatedListing = listing.put();
        Assert.isType(updatedListing, Listing);
        Assert.areEqual(updatedListing, listing);
    }
}

class ListingApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/listings.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/listings':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/listings/LST-212-458-762':
                        final listing = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(listing), null);
                }
            case 'PUT':
                if (url == 'https://api.conn.rocks/public/v1/listings/LST-212-458-762') {
                    return new Response(200, body, null);
                }
        }
        return new Response(404, null, null);
    }
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
