package connect.models;


/**
    Message in a `Conversation`.
**/
class Message extends IdModel {
    /** Primary id of Conversation object. **/
    public var conversation: String;


    /** Date of the Message creation. **/
    public var created: DateTime;


    /** User that created the message. **/
    public var creator: User;


    /** Actual message. **/
    public var text: String;

    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'creator' => 'User'
        ]);
    }
}
