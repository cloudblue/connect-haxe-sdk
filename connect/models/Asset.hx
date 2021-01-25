/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;


/**
    Represents a saleable item that can be provided/distributed in terms of one purchase.

    An asset is characterized by the following:

    - Every asset reflects some purchase (somebody purchases either a service or a good).
    - Purchase action can be reverted (canceled) or terminated when terms of purchase are expired.
    - Asset can be subscription-based (when customer pay for usage in some time terms) or
      one-time based.
    - Matter of asset is defined as list of purchased items with purchased quantities
      (asset items).
    - Item in asset may be either reservation-based, when customer decides how many items of SKU
      to be purchased or Pay-Per-User based when actual use of the SKU defines quantity for
      asset item.
    - Asset may be modified using change requests: either set of items may be changed or quantities
      of reservation-based items may be changed.
    - Some assets can be put into suspend state, when service is not actually provided
      and no charges happened.
    - Assets also may be parametrized by one or more parameters which differentiate
      one asset from another.
**/
class Asset extends IdModel {
    /**
        Assets may have one of the following statuses:

        - new: First purchase requested.
        - processing: Until first purchase request is either completed or rejected.
        - active: After the first purchase request is completed.
          NOTE: Asset stays active regardless of any other requests except cancel.
        - rejected: Asset becomes rejected once the first purchase request is rejected.
        - terminated: Asset becomes terminated once the 'cancel' request type is fulfilled.
        - suspended: Asset becomes suspended once 'suspend' request type is fulfilled.
    **/
    public var status: String;


    /** Identification for asset object on eCommerce. **/
    public var externalId: String;


    /** Id of asset in eCommerce system. **/
    public var externalUid: String;


    /** Name of asset. **/
    public var externalName: String;


    /** Product object reference. **/
    public var product: Product;


    /** Connection object reference. **/
    public var connection: Connection;


    /** Contract object reference. **/
    public var contract: Contract;


    /** Marketplace object reference. **/
    public var marketplace: Marketplace;


    /** Collection of product parameters. **/
    public var params: Collection<Param>;


    /** Supply chain accounts. **/
    public var tiers: Tiers;


    /** Collection of asset product items. **/
    public var items: Collection<Item>;


    /** Product and Marketplace Configuration Phase Parameter. **/
    public var configuration: Configuration;


    /** Events that have taken place on this asset (i.e: created, updated). **/
    public var events: Events;


    /**
        Lists all Assets that match the given filters. Supported filters are:

        - `id`
        - `conection.hub.id`
        - `connection.provider.id`
        - `tiers.customer.id`
        - `tiers.tier1.id`
        - `tiers.tier2.id`
        - `connection.id`
        - `status`
        - `created`
        - `updated`
        - `marketplace.id`
        - `contract.id`
        - `product.id`
        - `connection.type`

        @returns A Collection of Assets.
    **/
    public static function list(filters: Query) : Collection<Asset> {
        final assets = Env.getFulfillmentApi().listAssets(filters);
        return Model.parseArray(Asset, assets);
    }


    
    /** @returns The Asset with the given id, or `null` if it was not found. **/
    public static function get(id: String): Asset {
        try {
            final asset = Env.getFulfillmentApi().getAsset(id);
            return Model.parse(Asset, asset);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /** @returns A collection with all the requests for the `this` Asset. **/
    public function getRequests(): Collection<AssetRequest> {
        final requests = Env.getFulfillmentApi().getAssetRequests(this.id, this);
        return Model.parseArray(AssetRequest, requests);
    }


    /** @returns A collection with `this` Asset's new items. **/
    public function getNewItems(): Collection<Item> {
        return Collection._fromArray(this.items.toArray().filter(function(item) {
            return Std.parseInt(item.quantity) > 0 && Std.parseInt(item.oldQuantity) == 0;
        }));
    }


    /** @returns A collection with `this` Asset's changed items. **/
    public function getChangedItems(): Collection<Item> {
        return Collection._fromArray(this.items.toArray().filter(function(item) {
            return Std.parseInt(item.quantity) > 0 && Std.parseInt(item.oldQuantity) > 0;
        }));
    }


    /** @returns A collection with `this` Asset's removed items. **/
    public function getRemovedItems(): Collection<Item> {
        return Collection._fromArray(this.items.toArray().filter(function(item) {
            return Std.parseInt(item.quantity) == 0 && Std.parseInt(item.oldQuantity) > 0;
        }));
    }


    /** @returns The param with the given id, or `null` if it was not found. **/
    public function getParamById(paramId: String): Param {
        final params = this.params.toArray().filter(function(param) {
            return param.id == paramId;
        });
        return (params.length > 0) ? params[0] : null;
    }


    /** @returns The item with the given id, or `null` if it was not found. **/
    public function getItemById(itemId: String): Item {
        final items = this.items.toArray().filter(function(item) {
            return item.id == itemId;
        });
        return (items.length > 0) ? items[0] : null;
    }


    /** @returns The item with the given Manufacture Part Number, or `null` if it was not found. **/
    public function getItemByMpn(mpn: String): Item {
        final items = this.items.toArray().filter(function(item) {
            return item.mpn == mpn;
        });
        return (items.length > 0) ? items[0] : null;
    }


    /** @returns The item with the given global id, or `null` if it was not found. **/
    public function getItemByGlobalId(globalId: String): Item {
        final items = this.items.toArray().filter(function(item) {
            return item.globalId == globalId;
        });
        return (items.length > 0) ? items[0] : null;
    }


    /**
     * @return The `TierConfig` object for the customer tier of this asset, or `null`.
     */
    public function getCustomerConfig(): TierConfig {
        return (this.tiers.customer != null && this.product != null)
            ? this.tiers.customer.getTierConfig(this.product.id, 0)
            : null;
    }


    /**
     * @return The `TierConfig` object for the tier1 of this asset, or `null`.
     */
    public function getTier1Config(): TierConfig {
        return (this.tiers.tier1 != null && this.product != null)
            ? this.tiers.tier1.getTierConfig(this.product.id, 1)
            : null;
    }


    /**
     * @return The `TierConfig` object for the tier2 of this asset, or `null`.
     */
    public function getTier2Config(): TierConfig {
        return (this.tiers.tier2 != null && this.product != null)
            ? this.tiers.tier2.getTierConfig(this.product.id, 2)
            : null;
    }
}
