/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Blob;
import connect.util.Collection;

/**
    An object containing Distribution agreements with exact Hubs, enriched with additional
    information on details about the relation.

    A Marketplace is a way to list Products to specified regions (based on Distribution Agreements)
    and use specific Hubs to provision incoming Fulfillment requests.
**/
class Marketplace extends IdModel {
    /** Marketplace title, unique for an account. **/
    public var name: String;

    /** Markdown text describing the marketplace. **/
    public var description: String;

    /** How many active contracts were signed on the Marketplace. **/
    public var activeContracts: Int;

    /** Image identifying Marketplace object uploaded by user. **/
    public var icon: String;

    /** Provider account - the object owner. **/
    public var owner: Account;

    /** Collection of account-hub relations associated with the Marketplace object. **/
    public var hubs: Collection<ExtIdHub>;

    /**
        Zone where the marketplace is located, there can be following zones:
        AF, NA, OC, AS, EU, SA (It is continents).
    **/
    public var zone: String;

    /** Collection of country objects associated with marketplace. **/
    public var countries: Collection<Country>;

    /** Is marketplace available for sourcing? **/
    public var sourcing: Bool;

    public var currency: String;

    public function new() {
        super();
        this._setFieldClassNames([
            'owner' => 'Account',
            'hubs' => 'ExtIdHub',
            'countries' => 'Country'
        ]);
    }

    /**
        Lists all marketplaces that match the given filters. Supported filters are:

        - `id`
        - `name`
        - `owner.id`
        - `owner.name`
        - `sourcing`
        - `search`
        - `owner__id`

        @returns A Collection of Marketplaces.
    **/
    public static function list(filters: Query): Collection<Marketplace> {
        final marketplaces = Env.getMarketplaceApi().listMarketplaces(filters);
        return Model.parseArray(Marketplace, marketplaces);
    }

    /** @returns The Marketplace with the given id, or `null` if it was not found. **/
    public static function get(id: String): Marketplace {
        try {
            final marketplace = Env.getMarketplaceApi().getMarketplace(id);
            return Model.parse(Marketplace, marketplace);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Registers a new Marketplace on Connect, based on the data of `this` Marketplace.

        @returns The new Marketplace, or `null` if it couldn't be created.
    **/
    public function register(): Marketplace {
        try {
            final request = Env.getMarketplaceApi().createMarketplace(this.toString());
            return Model.parse(Marketplace, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Updates the Marketplace in the server with the data changed in `this` model.

        You should reassign your marketplace with the object returned by this method, so the next time
        you call `update` on the object, the SDK knows the fields that already got updated in a
        previous call, like this:

        ```
        marketplace = marketplace.update();
        ```

        @returns The Marketplace returned from the server, which should contain
        the same data as `this` Marketplace.
    **/
    public function update(): Marketplace {
        final diff = this._toDiff();
        final hasModifiedFields = Reflect.fields(diff).length > 1;
        if (hasModifiedFields) {
            final marketplace = Env.getMarketplaceApi().updateMarketplace(
                this.id,
                haxe.Json.stringify(diff));
            return Model.parse(Marketplace, marketplace);
        } else {
            return this;
        }
    }

    /**
     * Sets the icon of `this` Marketplace.
     */
    public function setIcon(icon: Blob): Bool {
        try {
            Env.getMarketplaceApi().setMarketplaceIcon(this.id, icon);
            return true;
        } catch (ex: Dynamic) {
            return false;
        }
    }

    /**
     * Removes `this` Marketplace from Connect.
     */
    public function remove(): Bool {
        try {
            Env.getMarketplaceApi().deleteMarketplace(this.id);
            return true;
        } catch (ex: Dynamic) {
            return false;
        }
    }
}
