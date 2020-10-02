/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;

/**
    Tier Accounts.
**/
class TierAccount extends IdModel {
    /** Only in case of filtering by this field. **/
    public var externalId: String;

    /** Tier name. **/
    public var name: String;

    /** Type of account in respect to operation. One of: test, preview, production. **/
    public var environment: String;

    /** Scopes of the tier account in asset tier chain. Possible: tier1, tier2, customer **/
    public var scopes: Collection<String>;

    /** Tier ContactInfo object. **/
    public var contactInfo: ContactInfo;

    /** Marketplace Object reference **/
    public var marketplace: Marketplace;

    /** Hub Reference **/
    public var hub: Hub;

    // Undocumented fields (they appear in PHP SDK)

    /** Only in case of filtering by this field. **/
    public var externalUid: String;

    /** Used for storing "Tax Registration ID" value of CloudBlue Commerce. **/
    public var taxId: String;

    /**
        Lists all TierAccounts that match the given filters. Supported filters are:

        - `id`
        - `external_id`
        - `external_uid`
        - `environment`
        - `scopes`
        - `marketplace.id`
        - `marketplace.name`
        - `hub.id`
        - `hub.name`
        - `search` (search based on all fields - generic search option)

        @returns A Collection of TierAccounts.
    **/
    public static function list(filters: Query) : Collection<TierAccount> {
        final accounts = Env.getTierApi().listTierAccounts(filters);
        return Model.parseArray(TierAccount, accounts);
    }

    /** @returns The TierAccount with the given id, or `null` if it was not found. **/
    public static function get(id: String): TierAccount {
        try {
            final account = Env.getTierApi().getTierAccount(id);
            return Model.parse(TierAccount, account);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
     * Gets the TierConfig for `this` TierAccount, based on the product id and
     * tier level specified.
     * @param productId Product id of the TierConfig we want to get.
     * @param tierLevel Tier level of the tier account.
     * @return TierConfig The `TierConfig`, or `null` if none could be found with the given parameters.
     */
    public function getTierConfig(productId: String, tierLevel: Int): TierConfig {
        final configs = TierConfig.list(new Query()
            .equal('account.id', this.id)
            .equal('product.id', productId)
            .equal('tier_level', Std.string(tierLevel)));
        return (configs.length() > 0)
            ? configs.get(0)
            : null;
    }
}
