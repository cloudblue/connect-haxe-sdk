/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.util.DateTime;

/** This class represent the period covered by a `UsageFile`. **/
class Period extends Model {
    /** Date & time from which usage records are considered in the usage file. **/
    public var from: DateTime;

    /** Date & time till which usage records are considered in the usage file. **/
    public var to: DateTime;

    /** Number of times which choosen UOM takes in period. **/
    public var delta: Int;

    /** Units of measure. One of: monthly, yearly. **/
    public var uom: String;

    public function new() {
        super();
        this._setFieldClassNames([
            'from' => 'DateTime',
            'to' => 'DateTime',
        ]);
    }
}
