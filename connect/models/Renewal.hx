/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Item renewal data.
**/
class Renewal extends Model {
    /** Date of renewal beginning. **/
    public var from: DateTime;


    /** Date of renewal end. **/
    public var to: DateTime;


    /** Size of renewal period. **/
    public var periodDelta: Int;


    /** Unit of measure for renewal period. One of: year, month, day, hour. **/
    public var periodUom: String;


    public function new() {
        super();
        this._setFieldClassNames([
            'from' => 'DateTime',
            'to' => 'DateTime'
        ]);
    }
}
