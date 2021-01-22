/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;
import connect.util.DateTime;


/**
    Conversation.
**/
class Conversation extends IdModel {
    /**
        The id of object based on which discussion is made, e.g. listing request.
        It can be any object.
    **/
    public var instanceId: String;


    /** Date of the Conversation creation. **/
    public var created: DateTime;


    /** Conversation topic. **/
    public var topic: String;


    /** Collection of messages. **/
    public var messages: Collection<Message>;


    /** Creator of the conversation. **/
    public var creator: User;


    /**
        Lists conversations.

        @returns A collection of Conversations.
    **/
    public static function list(filters: Query, ?request: Null<IdModel> = null) : Collection<Conversation> {
        final convs = Env.getGeneralApi().listConversations(filters, request);
        return Model.parseArray(Conversation, convs);
    }
    
    
    /**
        Creates a new conversation, linked to the given `instanceId`, and with the
        specified `topic`.

        @returns The created Conversation.
    **/
    public static function create(instanceId: String, topic: String, ?request: Null<IdModel> = null): Conversation {
        final conv = Env.getGeneralApi().createConversation(haxe.Json.stringify({
            instance_id: instanceId,
            topic: topic,
        }),request);
        return Model.parse(Conversation, conv);
    }


    /** @returns The Conversation with the given id, or `null` if it was not found. **/
    public static function get(id: String, ?request: Null<IdModel> = null): Conversation {
        try {
            final conv = Env.getGeneralApi().getConversation(id, request);
            return Model.parse(Conversation, conv);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Creates a new message in `this` Conversation with the given `text`, as long as the text
        is not the same as the one in the last `Message`.

        @returns The created `Message`, or `null` if the last message in the `Conversation` is
        the same as this one.
    **/
    public function createMessage(text: String, ?request: Null<IdModel> = null): Message {
        final msg = Env.getGeneralApi().createConversationMessage(
            this.id,
            haxe.Json.stringify({ text: text }),request);
        final message = Model.parse(Message, msg);
        if (this.messages == null) {
            this.messages = new Collection<Message>();
        }
        this.messages.push(message);
        return message;
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'creator' => 'User'
        ]);
    }
}
