/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;

class Subscription extends IdModel {
    public var status: String;
    public var events: Events;
    public var externalId: String;
    public var externalUid: String;
    public var product: Product;
    public var connection: Connection;
    public var params: Collection<Param>;
    public var tiers: Tiers;
    public var marketplace: Marketplace;
    public var contract: Contract;
    public var items: Collection<Item>;
    public var billing: BillingInfo;

    public function new() {
        super();
        this._setFieldClassNames([
            'billing' => 'BillingInfo',
        ]);
    }

    public static function list(filters: Query): Collection<Subscription> {
        final subscriptions = Env.getSubscriptionsApi().listRecurringAssets(filters);
        return Model.parseArray(Subscription, subscriptions);
    }

    public static function get(id: String): Subscription {
        try {
            final subscription = Env.getSubscriptionsApi().getRecurringAsset(id);
            return Model.parse(Subscription, subscription);
        } catch (ex: Dynamic) {
            return null;
        }
    }
}
