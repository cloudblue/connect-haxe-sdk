/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;

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

    public static function list(filters: Query): Collection<SubscriptionRequest> {
        final requests = Env.getSubscriptionsApi().listBillingRequests(filters);
        return Model.parseArray(SubscriptionRequest, requests);
    }

    public static function get(id: String): SubscriptionRequest {
        try {
            final request = Env.getSubscriptionsApi().getBillingRequest(id);
            return Model.parse(SubscriptionRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    public function register(): SubscriptionRequest {
        try {
            final request = Env.getSubscriptionsApi().createBillingRequest(this.toString());
            return Model.parse(SubscriptionRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    public function updateAttributes(): Bool {
        try {
            final data =
                (this.type == 'provider' && this.attributes != null && this.attributes.provider != null) ?
                    this.attributes.provider.toString() :
                (this.type == 'vendor' && this.attributes != null && this.attributes.vendor != null) ?
                    this.attributes.vendor.toString() :
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
