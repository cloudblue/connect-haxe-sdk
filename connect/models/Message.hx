package connect.models;


/**
    Message in a `Conversation`.
**/
class Message extends IdModel {
    /** Primary id of Conversation object. **/
    public var conversation(default, null): String;


    /** Date of the Message creation. **/
    public var created(default, null): String;


    /** User that created the message. **/
    public var creator(default, null): User;


    /** Actual message. **/
    public var text(default, null): String;


    /**
        Creates a new message, linked to the given `conversationId`, and with the specified `text`.

        @returns The created Conversation.
    **/
    public static function create(conversationId: String, text: String): Message {
        var msg = Environment.getGeneralApi().createConversationMessage(
            conversationId,
            haxe.Json.stringify({ text: text }));
        return Model.parse(Message, msg);
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'creator' => 'User'
        ]);
    }
}
