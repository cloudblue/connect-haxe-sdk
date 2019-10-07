package connect.models;


/**
    Represents a set of events that can take place on an object.
**/
class Events extends Model {
    /** Creation event. **/
    public var created(default, null): Event;


    /** Inquire event. **/
    public var inquired(default, null): Event;


    /** Pending event. **/
    public var pended(default, null): Event;


    /** Validation event. **/
    public var validated(default, null): Event;


    /** Update event. **/
    public var updated(default, null): Event;


    /** Approve event. **/
    public var approved(default, null): Event;


    /** Upload event. **/
    public var uploaded(default, null): Event;


    /** Submit event. **/
    public var submitted(default, null): Event;


    /** Accept event. **/
    public var accepted(default, null): Event;


    /** Reject event. **/
    public var rejected(default, null): Event;


    /** Close event. **/
    public var closed(default, null): Event;


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
