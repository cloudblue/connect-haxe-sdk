/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

@:dox(hide)
interface ISubscriptionsApi {
    public function listRecurringAssets(filters: Query) : String;
    public function getRecurringAsset(id: String): String;
    public function listBillingRequests(filters: Query): String;
    public function getBillingRequest(id: String): String;
    public function createBillingRequest(data: String): String;
    public function updateBillingRequestAttributes(id: String, data: String): String;
}
