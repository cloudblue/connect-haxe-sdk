/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

class BillingStatsInfo extends Model {
    public var lastRequest: BillingStatsRequest;

    /** Number of billing requests. **/
    public var count: Int;

    public function new() {
        super();
        this._setFieldClassNames([
            'lastRequest' => 'BillingStatsRequest',
        ]);
    }
}