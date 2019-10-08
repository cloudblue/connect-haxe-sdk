package tests.unit;

import connect.Dictionary;
import connect.Environment;
import connect.models.Conversation;
import tests.mocks.Mock;


class ConversationTest extends haxe.unit.TestCase {
    override public function setup() {
        Environment._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        var conversations = Conversation.list();
        assertEquals(1, conversations.length());
        assertEquals('CO-000-000-000', conversations.get(0).id);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listConversations'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listConversations', 0).toString());
    }


    public function testCreate() {
        // Check subject
        var conversation = Conversation.create('XXX', 'Nothing in particular');
        assertTrue(conversation != null);
        assertEquals('CO-000-000-000', conversation.id);
        assertEquals('XXX', conversation.instanceId);
        assertEquals('Nothing in particular', conversation.topic);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
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
        var conversation = Conversation.get('CO-000-000-000');
        assertTrue(conversation != null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getConversation'));
        assertEquals(
            ['CO-000-000-000'].toString(),
            apiMock.callArgs('getConversation', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        var conversation = Conversation.get('CO-XXX-XXX-XXX');
        assertTrue(conversation == null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getConversation'));
        assertEquals(
            ['CO-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getConversation', 0).toString());
    }


    public function testCreateMessage() {
        // Check subject
        var message = Conversation.get('CO-000-000-000').createMessage('Hello, world!');
        assertTrue(message != null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createConversationMessage'));
        assertEquals(
            ['CO-000-000-000', haxe.Json.stringify({text: 'Hello, world!'})].toString(),
            apiMock.callArgs('createConversationMessage', 0).toString());
    }
}
