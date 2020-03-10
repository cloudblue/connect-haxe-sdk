/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package test.mocks;

import connect.api.IMarketplaceApi;
import connect.api.Query;
import connect.util.Blob;
import haxe.Json;


class MarketplaceApiMock extends Mock implements IMarketplaceApi {
    public function new() {
        super();
        this.agreementList = Mock.parseJsonFile('test/mocks/data/agreement_list.json');
        this.listingList = Mock.parseJsonFile('test/mocks/data/listing_list.json');
        this.listingRequestList = Mock.parseJsonFile('test/mocks/data/listingrequest_list.json');
        this.marketplaceList = Mock.parseJsonFile('test/mocks/data/marketplace_list.json');
    }


    public function listAgreements(filters: Query): String {
        this.calledFunction('listAgreements', [filters]);
        return Json.stringify(this.agreementList);
    }


    public function createAgreement(body: String): String {
        this.calledFunction('createAgreement', [body]);
        return Json.stringify(this.agreementList[0]);
    }


    public function getAgreement(id: String): String {
        this.calledFunction('getAgreement', [id]);
        final agreements = this.agreementList.filter((agreement) -> agreement.id == id);
        if (agreements.length > 0) {
            return Json.stringify(agreements[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function updateAgreement(id: String, body: String): String {
        this.calledFunction('updateAgreement', [id, body]);
        return getAgreement(id);
    }


    public function removeAgreement(id: String): Void {
        this.calledFunction('removeAgreement', [id]);
    }


    public function listAgreementVersions(id: String): String {
        this.calledFunction('listAgreementVersions', [id]);
        return Json.stringify(this.agreementList);
    }


    public function newAgreementVersion(id: String, body: String): String {
        this.calledFunction('newAgreementVersion', [id, body]);
        final version = Json.parse(getAgreement(id));
        version.version++;
        return Json.stringify(version);
    }

    
    public function getAgreementVersion(id: String, version: String): String {
        this.calledFunction('getAgreementVersion', [id, version]);
        final ver = Json.parse(getAgreement(id));
        ver.version = Std.parseInt(version);
        return Json.stringify(ver);
    }


    public function removeAgreementVersion(id: String, version: String): Void {
        this.calledFunction('removeAgreementVersion', [id, version]);
    }


    public function listAgreementSubAgreements(id: String): String {
        this.calledFunction('listAgreementSubAgreements', [id]);
        return '[]';
    }


    public function createAgreementSubAgreement(id: String, body: String): String {
        this.calledFunction('createAgreementSubAgreement', [id, body]);
        return getAgreement(id);
    }


    public function listListings(filters: Query): String {
        this.calledFunction('listListings', [filters]);
        return Json.stringify(this.listingList);
    }


    public function getListing(id: String): String {
        this.calledFunction('getListing', [id]);
        final listings = this.listingList.filter((listing) -> listing.id == id);
        if (listings.length > 0) {
            return Json.stringify(listings[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function putListing(id: String, body: String): String {
        this.calledFunction('putListing', [id, body]);
        return getListing(id);
    }


    public function listListingRequests(filters: Query): String {
        this.calledFunction('listListingRequests', [filters]);
        return Json.stringify(this.listingRequestList);
    }


    public function getListingRequest(id: String): String {
        this.calledFunction('getListingRequest', [id]);
        final requests = this.listingRequestList.filter((request) -> request.id == id);
        if (requests.length > 0) {
            return Json.stringify(requests[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function createListingRequest(body: String): String {
        this.calledFunction('createListingRequest', [body]);
        return Json.stringify(this.listingRequestList[0]);
    }


    public function assignListingRequest(id: String): Void {
        this.calledFunction('assignListingRequest', [id]);
    }


    public function unassignListingRequest(id: String): Void {
        this.calledFunction('unassignListingRequest', [id]);
    }


    public function changeListingRequestToDraft(id: String): Void {
        this.calledFunction('changeListingRequestToDraft', [id]);
    }


    public function changeListingRequestToDeploying(id: String): Void {
        this.calledFunction('changeListingRequestToDeploying', [id]);
    }


    public function changeListingRequestToCompleted(id: String): Void {
        this.calledFunction('changeListingRequestToCompleted', [id]);
    }


    public function changeListingRequestToCancelled(id: String): Void {
        this.calledFunction('changeListingRequestToCancelled', [id]);
    }


    public function changeListingRequestToReviewing(id: String): Void {
        this.calledFunction('changeListingRequestToReviewing', [id]);
    }


    public function listMarketplaces(filters: Query): String {
        this.calledFunction('listMarketplaces', [filters]);
        return Json.stringify(this.marketplaceList);
    }


    public function createMarketplace(body: String): String {
        this.calledFunction('createMarketplace', [body]);
        return Json.stringify(this.marketplaceList[0]);
    }


    public function getMarketplace(id: String): String {
        this.calledFunction('getMarketplace', [id]);
        final marketplaces = this.marketplaceList.filter((marketplace) -> marketplace.id == id);
        if (marketplaces.length > 0) {
            return Json.stringify(marketplaces[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function updateMarketplace(id: String, body: String): String {
        this.calledFunction('updateMarketplace', [id, body]);
        return getMarketplace(id);
    }

    
    public function setMarketplaceIcon(id: String, data: Blob): Void {
        this.calledFunction('setMarketplaceIcon', [id, data]);
    }

    
    public function deleteMarketplace(id: String): Void {
        this.calledFunction('deleteMarketplace', [id]);
    }


    private final agreementList: Array<Dynamic>;
    private final listingList: Array<Dynamic>;
    private final listingRequestList: Array<Dynamic>;
    private final marketplaceList: Array<Dynamic>;
}
