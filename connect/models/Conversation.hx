package connect.models;

import connect.api.QueryParams;


/**
    Conversation.
**/
class Conversation extends IdModel {
    /**
        The id of object based on which discussion is made, e.g. listing request.
        It can be any object.
    **/
    public var instanceId(default, null): String;


    /** Date of the Conversation creation. **/
    public var created(default, null): String;


    /** Conversation topic. **/
    public var topic(default, null): String;


    /** Collection of messages. **/
    public var messages(default, null): Collection<Message>;


    /** Creator of the conversation. **/
    public var creator(default, null): User;


    /**
        Lists conversations.

        @returns A collection of Conversations.
    **/
    public static function list(filters: QueryParams) : Collection<Conversation> {
        var convs = Env.getGeneralApi().listConversations(filters);
        return Model.parseArray(Conversation, convs);
    }
    
    
    /**
        Creates a new conversation, linked to the given `instanceId`, and with the
        specified `topic`.

        @returns The created Conversation.
    **/
    public static function create(instanceId: String, topic: String): Conversation {
        var conv = Env.getGeneralApi().createConversation(haxe.Json.stringify({
            instance_id: instanceId,
            topic: topic
        }));
        return Model.parse(Conversation, conv);
    }


    /** @returns The Conversation with the given id, or `null` if it was not found. **/
    public static function get(id: String): Conversation {
        try {
            var conv = Env.getGeneralApi().getConversation(id);
            return Model.parse(Conversation, conv);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Creates a new message in `this` Conversation with the given `text`.

        This is a shortcut for calling `Message.create`.
    **/
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
