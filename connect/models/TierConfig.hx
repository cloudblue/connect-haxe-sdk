/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;

/** This class represents the configuration of a Tier. **/
class TierConfig extends IdModel {
    /** Name of Tier configuration. **/
    public var name: String;

    /** Full tier account representation (same as in `Asset`). **/
    public var account: TierAccount;

    /** Reference object to product (application). **/
    public var product: Product;

    /** Tier level for product from customer perspective. **/
    public var tierLevel: Int;

    /**
        List of TC parameter data objects as in Asset Object extended with unfilled parameters
        from product.
    **/
    public var params: Collection<Param>;

    /** Reference to Connection Object. **/
    public var connection: Connection;

    /** Reference to TCR. **/
    public var openRequest: TierConfigRequest;

    /** Template object. **/
    public var template: Template;

    /** Contract object reference. **/
    public var contract: Contract;

    /** Marketplace object reference. **/
    public var marketplace: Marketplace;

    /** List of Product and Marketplace Configuration Phase Parameter Context-Bound Object. **/
    public var configuration: Configuration;

    /** TierConfig events. **/
    public var events: Events;

    /** TierConfig tier accounts. **/
    public var tiers: Tiers;

    // Undocumented fields (they appear in PHP SDK)

    /** TierConfig status. **/
    public var status: String;

    public function new() {
        super();
        this._setFieldClassNames([
            'account' => 'TierAccount',
            'openRequest' => 'TierConfigRequest',
        ]);
    }

    /**
        Lists all TierConfigs that match the given filters. Supported filters are:

        - `id`
        - `account.id`
        - `product.id`
        - `connection.id`
        - `connection.type`
        - `tier_level`
        - `environent`
        - `search` (search based on all fields - generic search option)

        @returns A Collection of TierConfigs.
    **/
    public static function list(filters: Query) : Collection<TierConfig> {
        final configs = Env.getTierApi().listTierConfigs(filters);
        return Model.parseArray(TierConfig, configs);
    }

    /** @returns The TierConfig with the given id, or `null` if it was not found. **/
    public static function get(id: String): TierConfig {
        try {
            final account = Env.getTierApi().getTierConfig(id);
            return Model.parse(TierConfig, account);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /** @returns The `Param` with the given id, or `null` if it was not found. **/
    public function getParamById(paramId: String): Param {
        final params = this.params.toArray().filter(function(param) {
            return param.id == paramId;
        });
        return (params.length > 0) ? params[0] : null;
    }
}
