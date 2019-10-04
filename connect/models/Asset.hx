package connect.models;

import connect.api.QueryParams;


class Asset extends IdModel {
    public var status(default, null): String;
    public var externalId(default, null): String;
    public var externalUid(default, null): String;
    public var externalName(default, null): String;
    public var product(default, null): Product;
    public var connection(default, null): Connection;
    public var contract(default, null): Contract;
    public var marketplace(default, null): Marketplace;
    public var params(default, null): Collection<Param>;
    public var tiers(default, null): Tiers;
    public var items(default, null): Collection<Item>;
    public var configuration(default, null): Configuration;


    public static function list(?filters: QueryParams) : Collection<Asset> {
        var assets = Environment.getFulfillmentApi().listAssets(filters);
        return Model.parseArray(Asset, assets);
    }


    public static function get(id: String): Asset {
        var asset = Environment.getFulfillmentApi().getAsset(id);
        return Model.parse(Asset, asset);
    }


    public function getRequests(): Collection<Fulfillment> {
        var requests = Environment.getFulfillmentApi().getAssetRequests(this.id);
        return Model.parseArray(Fulfillment, requests);
    }


    public function getNewItems(): Collection<Item> {
        return Collection._fromArray(this.items._getInternalArray().filter(function(item) {
            return Std.parseInt(item.quantity) > 0 && Std.parseInt(item.oldQuantity) == 0;
        }));
    }


    public function getChangedItems(): Collection<Item> {
        return Collection._fromArray(this.items._getInternalArray().filter(function(item) {
            return Std.parseInt(item.quantity) > 0 && Std.parseInt(item.oldQuantity) > 0;
        }));
    }


    public function getRemovedItems(): Collection<Item> {
        return Collection._fromArray(this.items._getInternalArray().filter(function(item) {
            return Std.parseInt(item.quantity) == 0 && Std.parseInt(item.oldQuantity) > 0;
        }));
    }


    public function getParamById(paramId: String): Param {
        var params = this.params._getInternalArray().filter(function(param) {
            return param.id == paramId;
        });
        return (params.length > 0) ? params[0] : null;
    }


    public function getItemById(itemId: String): Item {
        var items = this.items._getInternalArray().filter(function(item) {
            return item.id == itemId;
        });
        return (items.length > 0) ? items[0] : null;
    }


    public function getItemByMpn(mpn: String): Item {
        var items = this.items._getInternalArray().filter(function(item) {
            return item.mpn == mpn;
        });
        return (items.length > 0) ? items[0] : null;
    }


    public function getItemByGlobalId(globalId: String): Item {
        var items = this.items._getInternalArray().filter(function(item) {
            return item.globalId == globalId;
        });
        return (items.length > 0) ? items[0] : null;
    }
}
