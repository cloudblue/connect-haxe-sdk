/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;
import connect.util.DateTime;


class Listing extends IdModel {
    /** Status of the listing. One of: listed, unlisted. **/
    public var status: String;


    /** Distribution contract. **/
    public var contract: Contract;


    /** Product reference. **/
    public var product: Product;


    /** Listing creation date. **/
    public var created: DateTime;


    /** Vendor account reference. **/
    public var vendor: Account;


    /** Provider account reference. **/
    public var provider: Account;


    /**
     * Indicates whether the product is available in wholesale catalog.
     * Object appears when product can be published.
     */
    public var sourcing: ListingSourcing;


    /** ListingRequest reference. **/
    public var pendingRequest: ListingRequest;


    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'vendor' => 'Account',
            'provider' => 'Account',
            'sourcing' => 'ListingSourcing',
            'pendingRequest' => 'ListingRequest',
        ]);
    }


    /**
        Lists all listings that match the given filters. Supported filters are:

        - status
        - contract
        - product
        - created_date
        - marketplace
        - sourcing__agreement
        - sourcing__published

        @returns A Collection of Listings.
    **/
    public static function list(filters: Query): Collection<Listing> {
        final listings = Env.getMarketplaceApi().listListings(filters);
        return Model.parseArray(Listing, listings);
    }


    /** @returns The Listing with the given id, or `null` if it was not found. **/
    public static function get(id: String): Listing {
        try {
            final agreement = Env.getMarketplaceApi().getListing(id);
            return Model.parse(Listing, agreement);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Puts the listing in the Connect platform with the data changed in `this` model.

        @returns The Listing returned from the server, which should contain
        the same data as `this` Listing.
    **/
    public function put(): Listing {
        final listing = Env.getMarketplaceApi().putListing(
            this.id,
            this.toString());
        return Model.parse(Listing, listing);
    }
}
