/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;

/**
 * This class represents assets with one or more reservation type items.
 */
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

    /**
        Lists all subscription assets that match the given filters. Supported filters are:

        - `status`
        - `events.created.at`
        - `events.created.at`
        - `billing.period.uom`
        - `billing.next_date`
        - `external_id`
        - `external_uid`
        - `product.id`
        - `product.name`
        - `connection.id`
        - `connection.type`
        - `connection.provider.id`
        - `connection.provider.name`
        - `connection.vendor.id`
        - `connection.vendor.name`
        - `connection.hub.id`
        - `connection.hub.name`
        - `marketplace.id`
        - `marketplace.name`
        - `tiers.customer.id`
        - `tiers.tier1.id`
        - `tiers.tier2.id`

        @returns A Collection of Subscriptions.
    **/
    public static function list(filters: Query): Collection<Subscription> {
        final subscriptions = Env.getSubscriptionsApi().listRecurringAssets(filters);
        return Model.parseArray(Subscription, subscriptions);
    }

    /** @returns The Subscription with the given id, or `null` if it was not found. **/
    public static function get(id: String): Subscription {
        try {
            final subscription = Env.getSubscriptionsApi().getRecurringAsset(id);
            return Model.parse(Subscription, subscription);
        } catch (ex: Dynamic) {
            return null;
        }
    }
}
