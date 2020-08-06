/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.util.Dictionary;

class SubscriptionRequestAttributes extends Model {
    public var vendor: Dictionary;
    public var provider: Dictionary;

    public function new() {
        super();
        this._setFieldClassNames([
            'vendor' => 'Dictionary',
            'provider' => 'Dictionary',
        ]);
    }
}
