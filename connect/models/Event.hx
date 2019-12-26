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
