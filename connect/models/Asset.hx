package connect.models;

import connect.api.ConnectApi;
import connect.api.IFulfillmentApi;
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


    public function list(?filters: QueryParams, ?api: IFulfillmentApi)
            : Collection<Asset> {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var assets = api.listAssets(filters);
        return Model.parseArray(Asset, assets);
    }
}
