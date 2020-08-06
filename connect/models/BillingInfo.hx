/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.util.DateTime;

class BillingInfo extends Model {
    public var stats: BillingStats;
    public var period: Period;
    public var nextDate: DateTime;
    public var anniversary: BillingAnniversary;

    public function new() {
        super();
        this._setFieldClassNames([
            'stats' => 'BillingStats',
            'nextDate' => 'DateTime',
            'anniversary' => 'BillingAnniversary',
        ]);
    }
}
