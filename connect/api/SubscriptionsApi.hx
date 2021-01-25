/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.models.IdModel;

@:dox(hide)
class SubscriptionsApi extends Base {
    private static final ASSETS_PATH = 'subscriptions/assets';
    private static final REQUESTS_PATH = 'subscriptions/requests';

    public function new() {
    }

    public function listRecurringAssets(filters: Query) : String {
        return ConnectHelper.get(ASSETS_PATH, null, null, filters, true);
    }

    public function getRecurringAsset(id: String): String {
        return ConnectHelper.get(ASSETS_PATH, id);
    }

    public function listBillingRequests(filters: Query): String {
        return ConnectHelper.get(REQUESTS_PATH, null, null, filters, true);
    }

    public function getBillingRequest(id: String): String {
        return ConnectHelper.get(REQUESTS_PATH, id);
    }

    public function createBillingRequest(data: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(REQUESTS_PATH, null, null, data);
    }

    public function updateBillingRequestAttributes(id: String, data: String): String {
        return ConnectHelper.put(REQUESTS_PATH, id, 'attributes', data);
    }
}
