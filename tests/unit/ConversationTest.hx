/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Conversation;
import connect.models.Message;
import connect.models.User;
import tests.mocks.Mock;


class ConversationTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        final conversations = Conversation.list(null);
        assertTrue(Std.is(conversations, Collection));
        assertEquals(1, conversations.length());
        assertTrue(Std.is(conversations.get(0), Conversation));
        assertEquals('CO-000-000-000', conversations.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listConversations'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listConversations', 0).toString());
    }


    public function testCreate() {
        // Check subject
        final conversation = Conversation.create('XXX', 'Nothing in particular');
        assertTrue(Std.is(conversation, Conversation));
        assertEquals('CO-000-000-000', conversation.id);
        assertEquals('XXX', conversation.instanceId);
        assertEquals('Nothing in particular', conversation.topic);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createConversation'));
        assertEquals(
            [haxe.Json.stringify({
                instance_id: 'XXX',
                topic: 'Nothing in particular'
            })].toString(),
            apiMock.callArgs('createConversation', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final conversation = Conversation.get('CO-000-000-000');
        assertTrue(Std.is(conversation, Conversation));
        assertTrue(Std.is(conversation.messages, Collection));
        assertEquals(1, conversation.messages.length());
        assertTrue(Std.is(conversation.messages.get(0), Message));
        assertTrue(Std.is(conversation.messages.get(0).creator, User));
        assertTrue(Std.is(conversation.creator, User));
        assertEquals('CO-000-000-000', conversation.id);
        assertEquals('PR-5852-1608-0000', conversation.instanceId);
        assertEquals('2018-12-18T12:49:34+00:00', conversation.created.toString());
        assertEquals('Topic', conversation.topic);
        
        final message = conversation.messages.get(0);
        assertEquals('ME-000-000-000', message.id);
        assertEquals('CO-000-000-000', message.conversation);
        assertEquals('2018-12-18T13:03:30+00:00', message.created.toString());
        assertEquals('UR-000-000-000', message.creator.id);
        assertEquals('Some User', message.creator.name);
        assertEquals('Message', message.text);
        
        final creator = conversation.creator;
        assertEquals('UR-922-977-649', creator.id);
        assertEquals('Some User', creator.name);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getConversation'));
        assertEquals(
            ['CO-000-000-000'].toString(),
            apiMock.callArgs('getConversation', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final conversation = Conversation.get('CO-XXX-XXX-XXX');
        assertTrue(conversation == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getConversation'));
        assertEquals(
            ['CO-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getConversation', 0).toString());
    }


    public function testCreateMessage() {
        // Check subject
        final message = Conversation.get('CO-000-000-000').createMessage('Hello, world!');
        assertTrue(Std.is(message, Message));

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createConversationMessage'));
        assertEquals(
            ['CO-000-000-000', haxe.Json.stringify({text: 'Hello, world!'})].toString(),
            apiMock.callArgs('createConversationMessage', 0).toString());
    }
}
