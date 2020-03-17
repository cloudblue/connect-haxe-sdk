/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
import connect.models.Listing;
import connect.models.ListingRequest;
import connect.models.Product;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class ListingTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IMarketplaceApi', 'test.mocks.MarketplaceApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final listings = Listing.list(null);
        Assert.isType(listings, Collection);
        Assert.areEqual(1, listings.length());
        Assert.isType(listings.get(0), Listing);
        Assert.areEqual('LST-212-458-762', listings.get(0).id);

        // Check mock
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listListings'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listListings', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
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

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getListing'));
        Assert.areEqual(
            ['LST-212-458-762'].toString(),
            apiMock.callArgs('getListing', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final listing = Listing.get('LST-XXX-XXX-XXX');
        Assert.isNull(listing);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getListing'));
        Assert.areEqual(
            ['LST-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getListing', 0).toString());
    }


    @Test
    public function testPut() {
        // Check subject
        final listing = Listing.get('LST-212-458-762');
        listing.status = 'listed';
        final updatedListing = listing.put();
        Assert.isType(updatedListing, Listing);
        Assert.areEqual(Listing.get('LST-212-458-762').toString(), updatedListing.toString());
        // ^ The mock returns that request

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('putListing'));
        Assert.areEqual(
            [listing.id, listing._toDiffString()].toString(),
            apiMock.callArgs('putListing', 0).toString());
    }


    @Test
    public function testPutNoChanges() {
        // Check subject
        final listing = Listing.get('LST-212-458-762');
        final updatedListing = listing.put();
        Assert.isNull(updatedListing);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('putListing'));
    }
}
