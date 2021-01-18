/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.logger.Logger;
import connect.models.Conversation;
import connect.models.Message;
import connect.models.User;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class ConversationTest {
    @Before
    public function setup() {
        Env._reset(new ConversationApiClientMock());
    }

    @Test
    public function testList() {
        final conversations = Conversation.list(null);
        Assert.isType(conversations, Collection);
        Assert.areEqual(1, conversations.length());
        Assert.isType(conversations.get(0), Conversation);
        Assert.areEqual('CO-000-000-000', conversations.get(0).id);
    }

    @Test
    public function testCreate() {
        final conversation = Conversation.create('XXX', 'Nothing in particular');
        Assert.isType(conversation, Conversation);
        Assert.areEqual('XXX', conversation.instanceId);
        Assert.areEqual('Nothing in particular', conversation.topic);
    }

    @Test
    public function testGetOk() {
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
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Conversation.get('CO-XXX-XXX-XXX'));
    }

    @Test
    public function testCreateMessage() {
        final message = Conversation.get('CO-000-000-000').createMessage('Hello, world!');
        Assert.isType(message, Message);
    }
}

class ConversationApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/conversations.json';

    public function new() {
    }
    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger:Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/conversations':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/conversations/CO-000-000-000':
                        final conv = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(conv), null);
                }
            case 'POST':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/conversations':
                        return new Response(200, body, null);
                    case 'https://api.conn.rocks/public/v1/conversations/CO-000-000-000/messages':
                        return new Response(200, body, null);
                }
        }
        return new Response(404, null, null);
    }

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
