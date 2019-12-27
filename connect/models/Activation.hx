/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Contract activation information.
**/
class Activation extends Model {
    /** Activation link. **/
    public var link: String;


    /** Activation message. **/
    public var message: String;


    /** Activation date. **/
    public var date: DateTime;

    public function new() {
        super();
        this._setFieldClassNames([
            'date' => 'DateTime',
        ]);
    }
}
