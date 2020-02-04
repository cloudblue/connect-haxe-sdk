/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Env;
import connect.models.Conversation;
import connect.models.Message;
import connect.models.User;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import tests.mocks.Mock;


class ConversationTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final conversations = Conversation.list(null);
        Assert.isType(conversations, Collection);
        Assert.areEqual(1, conversations.length());
        Assert.isType(conversations.get(0), Conversation);
        Assert.areEqual('CO-000-000-000', conversations.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listConversations'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listConversations', 0).toString());
    }


    @Test
    public function testCreate() {
        // Check subject
        final conversation = Conversation.create('XXX', 'Nothing in particular');
        Assert.isType(conversation, Conversation);
        Assert.areEqual('CO-000-000-000', conversation.id);
        Assert.areEqual('XXX', conversation.instanceId);
        Assert.areEqual('Nothing in particular', conversation.topic);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createConversation'));
        Assert.areEqual(
            [haxe.Json.stringify({
                instance_id: 'XXX',
                topic: 'Nothing in particular'
            })].toString(),
            apiMock.callArgs('createConversation', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
        final conversation = Conversation.get('CO-000-000-000');
        Assert.isType(conversation, Conversation);
        Assert.isType(conversation.messages, Collection);
        Assert.areEqual(1, conversation.messages.length());
        Assert.isType(conversation.messages.get(0), Message);
        Assert.isType(conversation.messages.get(0).creator, User);
        Assert.isType(conversation.creator, User);
        Assert.areEqual('CO-000-000-000', conversation.id);
        Assert.areEqual('PR-5852-1608-0000', conversation.instanceId);
        Assert.areEqual('2018-12-18T12:49:34+00:00', conversation.created.toString());
        Assert.areEqual('Topic', conversation.topic);
        
        final message = conversation.messages.get(0);
        Assert.areEqual('ME-000-000-000', message.id);
        Assert.areEqual('CO-000-000-000', message.conversation);
        Assert.areEqual('2018-12-18T13:03:30+00:00', message.created.toString());
        Assert.areEqual('UR-000-000-000', message.creator.id);
        Assert.areEqual('Some User', message.creator.name);
        Assert.areEqual('Message', message.text);
        
        final creator = conversation.creator;
        Assert.areEqual('UR-922-977-649', creator.id);
        Assert.areEqual('Some User', creator.name);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getConversation'));
        Assert.areEqual(
            ['CO-000-000-000'].toString(),
            apiMock.callArgs('getConversation', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final conversation = Conversation.get('CO-XXX-XXX-XXX');
        Assert.isNull(conversation);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getConversation'));
        Assert.areEqual(
            ['CO-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getConversation', 0).toString());
    }


    @Test
    public function testCreateMessage() {
        // Check subject
        final message = Conversation.get('CO-000-000-000').createMessage('Hello, world!');
        Assert.isType(message, Message);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createConversationMessage'));
        Assert.areEqual(
            ['CO-000-000-000', haxe.Json.stringify({text: 'Hello, world!'})].toString(),
            apiMock.callArgs('createConversationMessage', 0).toString());
    }
}
