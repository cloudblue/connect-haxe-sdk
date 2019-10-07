package connect.models;


/**
    Represents the date and user that caused an event.
**/
class Event extends Model {
    /** Date when the event occurred. **/
    public var at(default, null): String;


    /** User that caused the event. **/
    public var by(default, null): User;


    public function new() {
        super();
        this._setFieldClassNames([
            'by' => 'User'
        ]);
    }
}
