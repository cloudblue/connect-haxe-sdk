/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
import connect.models.Listing;
import connect.models.ListingRequest;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class ListingRequestTest {
    /*
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IMarketplaceApi', 'test.mocks.MarketplaceApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final requests = ListingRequest.list(null);
        Assert.isType(requests, Collection);
        Assert.areEqual(1, requests.length());
        Assert.isType(requests.get(0), ListingRequest);
        Assert.areEqual('LSTR-409-308-930', requests.get(0).id);

        // Check mock
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listListingRequests'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listListingRequests', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
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

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getListingRequest'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('getListingRequest', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final listing = ListingRequest.get('LSTR-XXX-XXX-XXX');
        Assert.isNull(listing);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getListingRequest'));
        Assert.areEqual(
            ['LSTR-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getListingRequest', 0).toString());
    }


    @Test
    public function testRegister() {
        // Check subject
        final request = new ListingRequest().register();
        Assert.isType(request, ListingRequest);
        Assert.areEqual('LSTR-409-308-930', request.id);

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createListingRequest'));
        Assert.areEqual(
            [new ListingRequest()].toString(),
            apiMock.callArgs('createListingRequest', 0).toString());
    }


    @Test
    public function testAssign() {
        // Check subject
        final request = ListingRequest.get('LSTR-409-308-930');
        request.assign();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('assignListingRequest'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('assignListingRequest', 0).toString());
    }


    @Test
    public function testUnassign() {
        // Check subject
        ListingRequest.get('LSTR-409-308-930').unassign();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('unassignListingRequest'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('unassignListingRequest', 0).toString());
    }


    @Test
    public function testChangetoDraft() {
        // Check subject
        ListingRequest.get('LSTR-409-308-930').changeToDraft();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeListingRequestToDraft'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('changeListingRequestToDraft', 0).toString());
    }


    @Test
    public function testChangetoDeploying() {
        // Check subject
        ListingRequest.get('LSTR-409-308-930').changeToDeploying();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeListingRequestToDeploying'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('changeListingRequestToDeploying', 0).toString());
    }


    @Test
    public function testChangetoCompleted() {
        // Check subject
        ListingRequest.get('LSTR-409-308-930').changeToCompleted();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeListingRequestToCompleted'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('changeListingRequestToCompleted', 0).toString());
    }


    @Test
    public function testChangetoCanceled() {
        // Check subject
        ListingRequest.get('LSTR-409-308-930').changeToCanceled();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeListingRequestToCanceled'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('changeListingRequestToCanceled', 0).toString());
    }


    @Test
    public function testChangetoReviewing() {
        // Check subject
        ListingRequest.get('LSTR-409-308-930').changeToReviewing();

        // Check mocks
        final apiMock = cast(Env.getMarketplaceApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('changeListingRequestToReviewing'));
        Assert.areEqual(
            ['LSTR-409-308-930'].toString(),
            apiMock.callArgs('changeListingRequestToReviewing', 0).toString());
    }
    */
}
