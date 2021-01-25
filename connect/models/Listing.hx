/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;
import connect.util.DateTime;

/**
 * A Listing represents the the actual publishing procedure in the Connect platform.
 */
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

        - `status`
        - `contract`
        - `product`
        - `created_date`
        - `marketplace`
        - `sourcing__agreement`
        - `sourcing__published`

        @returns A Collection of Listings.
    **/
    public static function list(filters: Query): Collection<Listing> {
        final listings = Env.getMarketplaceApi().listListings(filters);
        return Model.parseArray(Listing, listings);
    }

    /** @returns The Listing with the given id, or `null` if it was not found. **/
    public static function get(id: String): Listing {
        try {
            final listing = Env.getMarketplaceApi().getListing(id);
            return Model.parse(Listing, listing);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Puts the listing in the Connect platform with the data changed in `this` model.

        You should reassign your listing with the object returned by this method, so the next time
        you call `put` on the object, the SDK knows the fields that already got updated in a
        previous call, like this:

        ```
        listing = listing.put();
        ```

        @returns The Listing returned from the server, which should contain
        the same data as `this` Listing.
    **/
    public function put(): Listing {
        final diff = this._toDiff();
        final hasModifiedFields = Reflect.fields(diff).length > 1;
        if (hasModifiedFields) {
            final listing = Env.getMarketplaceApi().putListing(
                this.id,
                haxe.Json.stringify(diff),this);
            return Model.parse(Listing, listing);
        } else {
            return this;
        }
    }
}
