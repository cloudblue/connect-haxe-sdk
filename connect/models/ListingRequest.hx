/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;
import connect.util.DateTime;


/**
 * Represents a change request for a Listing object.
 */
class ListingRequest extends IdModel {
    /** Type of the listing request. One of: new, update, remove. **/
    public var type: String;


    /** Version of the product attached to the Listing Request. **/
    public var product: Product;


    /** Status of the listing request. One of: draft, reviewing, deploying, completed, canceled. **/
    public var state: String;

    
    /** Listing Object representation. **/
    public var listing: Listing;


    /** Listing Request creation date. **/
    public var created: DateTime;


    /** Listing Request update date. **/
    public var updated: DateTime;


    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'updated' => 'DateTime',
        ]);
    }


    /**
        Lists all listing requests that match the given filters. Supported filters are:

        - `type`
        - `status`
        - `listing`
        - `creator`
        - `assignee`
        - `created_date`
        - `notes`

        @returns A Collection of ListingRequests.
    **/
    public static function list(filters: Query): Collection<ListingRequest> {
        final requests = Env.getMarketplaceApi().listListingRequests(filters);
        return Model.parseArray(ListingRequest, requests);
    }


    /** @returns The ListingRequest with the given id, or `null` if it was not found. **/
    public static function get(id: String): ListingRequest {
        try {
            final request = Env.getMarketplaceApi().getListingRequest(id);
            return Model.parse(ListingRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Registers a new ListingRequest on Connect, based on the data of `this` ListingRequest.

        @returns The new ListingRequest, or `null` if it couldn't be created.
    **/
    public function register(): ListingRequest {
        try {
            final request = Env.getMarketplaceApi().createListingRequest(this.toString());
            return Model.parse(ListingRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Assigns this request to the user whose authorization is stored in the configuration.
    **/
    public function assign(): Void {
        Env.getMarketplaceApi().assignListingRequest(this.id);
    }


    /**
        Unassigns this request from the user is was assigned to.
    **/
    public function unassign(): Void {
        Env.getMarketplaceApi().unassignListingRequest(this.id);
    }


    /**
        Changes the state of the request to "draft".
    **/
    public function changeToDraft(): Void {
        Env.getMarketplaceApi().changeListingRequestToDraft(this.id);
    }


    /**
        Changes the state of the request to "deploying".
    **/
    public function changeToDeploying(): Void {
        Env.getMarketplaceApi().changeListingRequestToDeploying(this.id);
    }


    /**
        Changes the state of the request to "completed".
    **/
    public function changeToCompleted(): Void {
        Env.getMarketplaceApi().changeListingRequestToCompleted(this.id);
    }


    /**
        Changes the state of the request to "canceled".
    **/
    public function changeToCanceled(): Void {
        Env.getMarketplaceApi().changeListingRequestToCanceled(this.id);
    }


    /**
        Changes the state of the request to "reviewing".
    **/
    public function changeToReviewing(): Void {
        Env.getMarketplaceApi().changeListingRequestToReviewing(this.id);
    }
}
