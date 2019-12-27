/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Represents the date and user that caused an event.
**/
class Event extends Model {
    /** Date when the event occurred. **/
    public var at: DateTime;


    /** User that caused the event. **/
    public var by: User;


    public function new() {
        super();
        this._setFieldClassNames([
            'at' => 'DateTime',
            'by' => 'User'
        ]);
    }
}
