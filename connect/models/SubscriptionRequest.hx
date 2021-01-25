/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;

/**
 * Represents a vendor (generated) or provider (uploaded) billing of a `Subscription`.
 */
class SubscriptionRequest extends IdModel {
    /** One of: provider, vendor. **/
    public var type: String;
    public var events: Events;
    public var asset: Subscription;
    public var items: Collection<Item>;
    public var attributes: SubscriptionRequestAttributes;
    public var period: Period;

    public function new() {
        super();
        this._setFieldClassNames([
            'asset' => 'Subscription',
            'attributes' => 'SubscriptionRequestAttributes',
        ]);
    }

        /**
        Lists all requests that match the given filters. Supported filters are:

        - `id`
        - `type`
        - `period.uom`
        - `period.from`
        - `period.to`
        - `events.created.at` (le, ge)
        - `events.updated.at` (le, ge)
        - `asset.id`
        - `asset.billing.period.uom`
        - `asset.billing.next_date`
        - `asset.external_id`
        - `asset.external_uid`
        - `asset.product.id`
        - `asset.product.name`
        - `asset.connection.id`
        - `asset.connection.type`
        - `asset.connection.provider.id`
        - `asset.connection.provider.name`
        - `asset.connection.vendor.id`
        - `asset.connection.vendor.name`
        - `asset.connection.hub.id`
        - `asset.connection.hub.name`
        - `asset.marketplace.id`
        - `asset.marketplace.name`
        - `asset.tiers.customer.id`
        - `asset.tiers.tier1.id`
        - `asset.tiers.tier2.id`

        @returns A Collection of SubscriptionRequests.
    **/
    public static function list(filters: Query): Collection<SubscriptionRequest> {
        final requests = Env.getSubscriptionsApi().listBillingRequests(filters);
        return Model.parseArray(SubscriptionRequest, requests);
    }


    /** @returns The SubscriptionRequest with the given id, or `null` if it was not found. **/
    public static function get(id: String): SubscriptionRequest {
        try {
            final request = Env.getSubscriptionsApi().getBillingRequest(id);
            return Model.parse(SubscriptionRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Registers a new SubscriptionRequest on Connect, based on the data of `this` SubscriptionRequest.

        @returns The new SubscriptionRequest, or `null` if it couldn't be created.
    **/
    public function register(): SubscriptionRequest {
        try {
            final request = Env.getSubscriptionsApi().createBillingRequest(this.toString(),this);
            return Model.parse(SubscriptionRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Updates the request in the server with the attributes changed in `this` model.

        Only the attributes corresponding to the type (vendor or provider) will be updated.

        @returns Whether the attributes were correctly updated.
    **/
    public function updateAttributes(): Bool {
        try {
            final data =
                (this.type == 'provider' && this.attributes != null && this.attributes.provider != null) ?
                    '{"provider": ${this.attributes.provider.toString()}}' :
                (this.type == 'vendor' && this.attributes != null && this.attributes.vendor != null) ?
                    '{"vendor": ${this.attributes.vendor.toString()}}' :
                null;
            final attr = (data != null)
                ? Env.getSubscriptionsApi().updateBillingRequestAttributes(this.id, data)
                : null;
            if (attr != null) {
                this.attributes = Model.parse(SubscriptionRequestAttributes, attr);
                return true;
            } else {
                return false;
            }
        } catch (ex: Dynamic) {
            return false;
        }
    }
}
