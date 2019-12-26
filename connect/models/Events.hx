/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Represents a set of events that can take place on an object.
**/
class Events extends Model {
    /** Creation event. **/
    public var created: Event;


    /** Inquire event. **/
    public var inquired: Event;


    /** Pending event. **/
    public var pended: Event;


    /** Validation event. **/
    public var validated: Event;


    /** Update event. **/
    public var updated: Event;


    /** Approve event. **/
    public var approved: Event;


    /** Upload event. **/
    public var uploaded: Event;


    /** Submit event. **/
    public var submitted: Event;


    /** Accept event. **/
    public var accepted: Event;


    /** Reject event. **/
    public var rejected: Event;


    /** Close event. **/
    public var closed: Event;


    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'Event',
            'inquired' => 'Event',
            'pended' => 'Event',
            'validated' => 'Event',
            'updated' => 'Event',
            'approved' => 'Event',
            'uploaded' => 'Event',
            'submitted' => 'Event',
            'accepted' => 'Event',
            'rejected' => 'Event',
            'closed' => 'Event',
        ]);
    }
}
