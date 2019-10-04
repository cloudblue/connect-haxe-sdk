package connect.models;


class Message extends IdModel {
    public var conversation(default, null): String;
    public var created(default, null): String;
    public var creator(default, null): User;
    public var text(default, null): String;


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
