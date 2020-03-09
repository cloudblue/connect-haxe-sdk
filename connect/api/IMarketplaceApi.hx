/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.util.Blob;


@:dox(hide)
interface IMarketplaceApi {
    public function listAgreements(filters: Query): String;
    public function createAgreement(body: String): String;
    public function getAgreement(id: String): String;
    public function updateAgreement(id: String, body: String): String;
    public function removeAgreement(id: String): Void;
    //public function getAgreementDocument(id: String): String;
    public function listAgreementVersions(id: String): String;
    public function newAgreementVersion(id: String, body: String): String;
    public function getAgreementVersion(id: String, version: String): String;
    public function removeAgreementVersion(id: String, version: String): Void;
    //public function getAgreementVersionDocument(id: String, version: String): String;
    public function listAgreementSubAgreements(id: String): String;
    public function createAgreementSubAgreement(id: String, body: String): String;

    /*
    // These calls appear in Dev in Connect Public API, so ignore by now
    public function listAgreementContracts(id: String): String;
    public function createAgreementContract(id: String, body: String): String;
    public function listContracts(filters: Query): String;
    public function getContract(id: String): String;
    public function updateContract(id: String, body: String): String;
    public function removeContract(id: String): Void;
    public function signContract(id: String, code: String): Void;
    public function enrollDistributionContract(id: String): Void;
    public function refineDistributionContract(id: String): Void;
    public function rejectDistributionContract(id: String): Void;
    public function terminateActiveContract(id: String): Void;
    public function listContractVersions(id: String): String;
    public function getContractVersion(id: String, version: String): String;
    */

    public function listListings(filters: Query): String;
    public function getListing(id: String): String;
    public function putListing(id: String, body: String): String;
    public function listListingRequests(filters: Query): String;
    public function getListingRequest(id: String): String;
    public function createListingRequest(body: String): String;
    public function assignListingRequest(id: String): Void;
    public function unassignListingRequest(id: String): Void;
    public function changeListingRequestToDraft(id: String): Void;
    public function changeListingRequestToDeploying(id: String): Void;
    public function changeListingRequestToCompleted(id: String): Void;
    public function changeListingRequestToCancelled(id: String): Void;
    public function changeListingRequestToReviewing(id: String): Void;

    public function listMarketplaces(filters: Query): String;
    public function createMarketplace(body: String): String;
    public function getMarketplace(id: String): String;
    public function updateMarketplace(id: String, body: String): String;
    public function setMarketplaceIcon(id: String, data: Blob): Void;
    public function deleteMarketplace(id: String): Void;
}
