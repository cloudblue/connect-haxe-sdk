/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.models.IdModel;
import connect.util.Blob;

class MarketplaceApi {
    public static final AGREEMENTS_PATH = 'agreements';
    public static final LISTINGS_PATH = 'listings';
    public static final LISTINGREQUESTS_PATH = 'listing-requests';
    public static final MARKETPLACES_PATH = 'marketplaces';

    public function new() {
    }

    public function listAgreements(filters: Query): String {
        return ConnectHelper.get(AGREEMENTS_PATH, null, null, filters);
    }

    public function createAgreement(body: String): String {
        return ConnectHelper.post(AGREEMENTS_PATH, null, null, body);
    }

    public function getAgreement(id: String): String {
        return ConnectHelper.get(AGREEMENTS_PATH, id);
    }

    public function updateAgreement(id: String, body: String): String {
        return ConnectHelper.put(AGREEMENTS_PATH, id, null, body);
    }

    public function removeAgreement(id: String): Void {
        ConnectHelper.delete(AGREEMENTS_PATH, id);
    }

    public function listAgreementVersions(id: String): String {
        return ConnectHelper.get(AGREEMENTS_PATH, id, 'versions');
    }

    public function newAgreementVersion(id: String, body: String): String {
        return ConnectHelper.post(AGREEMENTS_PATH, id, 'versions', body);
    }

    public function getAgreementVersion(id: String, version: String): String {
        return ConnectHelper.get(AGREEMENTS_PATH, id, 'version/$version');
    }

    public function removeAgreementVersion(id: String, version: String): Void {
        ConnectHelper.delete(AGREEMENTS_PATH, id, 'version/$version');
    }

    public function listAgreementSubAgreements(id: String): String {
        return ConnectHelper.get(AGREEMENTS_PATH, id, AGREEMENTS_PATH);
    }

    public function createAgreementSubAgreement(id: String, body: String): String {
        return ConnectHelper.post(AGREEMENTS_PATH, id, AGREEMENTS_PATH, body);
    }

    public function listListings(filters: Query): String {
        return ConnectHelper.get(LISTINGS_PATH, null, null, filters);
    }

    public function getListing(id: String): String {
        return ConnectHelper.get(LISTINGS_PATH, id);
    }

    public function putListing(id: String, body: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.put(LISTINGS_PATH, id, null, body, currentRequest);
    }

    public function listListingRequests(filters: Query): String {
        return ConnectHelper.get(LISTINGREQUESTS_PATH, null, null, filters);
    }

    public function getListingRequest(id: String): String {
        return ConnectHelper.get(LISTINGREQUESTS_PATH, id);
    }

    public function createListingRequest(body: String): String {
        return ConnectHelper.post(LISTINGREQUESTS_PATH, null, null, body);
    }

    public function assignListingRequest(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'assign');
    }

    public function unassignListingRequest(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'unassign');
    }

    public function changeListingRequestToDraft(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'refine');
    }

    public function changeListingRequestToDeploying(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'deploy');
    }

    public function changeListingRequestToCompleted(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'complete');
    }

    public function changeListingRequestToCanceled(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'cancel');
    }

    public function changeListingRequestToReviewing(id: String): Void {
        ConnectHelper.post(LISTINGREQUESTS_PATH, id, 'submit');
    }

    public function listMarketplaces(filters: Query): String {
        return ConnectHelper.get(MARKETPLACES_PATH, null, null, filters);
    }

    public function createMarketplace(body: String): String {
        return ConnectHelper.post(MARKETPLACES_PATH, null, null, body);
    }

    public function getMarketplace(id: String): String {
        return ConnectHelper.get(MARKETPLACES_PATH, id);
    }

    public function updateMarketplace(id: String, body: String): String {
        return ConnectHelper.put(MARKETPLACES_PATH, id, null, body);
    }

    public function setMarketplaceIcon(id: String, data: Blob): Void {
        ConnectHelper.postFile(MARKETPLACES_PATH, id, 'icon', 'name', 'marketplace.png', data);
    }

    public function deleteMarketplace(id: String): Void {
        ConnectHelper.delete(MARKETPLACES_PATH, id);
    }
}
