/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

class BillingStats extends Model {
    public var vendor: BillingStatsInfo;
    public var provider: BillingStatsInfo;

    public function new() {
        super();
        this._setFieldClassNames([
            'vendor' => 'BillingStatsInfo',
            'provider' => 'BillingStatsInfo',
        ]);
    }
}