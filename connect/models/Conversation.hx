package connect.models;

import connect.api.QueryParams;


class Conversation extends IdModel {
    public var instanceId(default, null): String;
    public var created(default, null): String;
    public var topic(default, null): String;
    public var messages(default, null): Collection<Message>;
    public var creator(default, null): User;


    public static function list(?filters: QueryParams) : Collection<Conversation> {
        var convs = Environment.getGeneralApi().listConversations(filters);
        return Model.parseArray(Conversation, convs);
    }
    
    
    public static function create(instanceId: String, topic: String): Conversation {
        var conv = Environment.getGeneralApi().createConversation(haxe.Json.stringify({
            instance_id: instanceId,
            topic: topic
        }));
        return Model.parse(Conversation, conv);
    }


    public static function get(id: String): Conversation {
        var conv = Environment.getGeneralApi().getConversation(id);
        return Model.parse(Conversation, conv);
    }


    public function createMessage(text: String): Message {
        var msg = Message.create(this.id, text);
        this.messages.push(msg);
        return msg;
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'creator' => 'User'
        ]);
    }
}
