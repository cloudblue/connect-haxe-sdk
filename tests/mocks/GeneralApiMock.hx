package tests.mocks;

import connect.api.IGeneralApi;
import connect.api.QueryParams;


class GeneralApiMock extends Mock implements IGeneralApi {
    public function new() {
        super();
        this.accountList = Mock.parseJsonFile('tests/mocks/data/account_list.json');
        this.conversationList = Mock.parseJsonFile('tests/mocks/data/conversation_list.json');
        this.userList = Mock.parseJsonFile('tests/mocks/data/user_list.json');
    }


    public function listAccounts(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listAccounts', [filters]);
        return this.accountList.map(function(account) { return Reflect.copy(account); });
    }


    public function createAccount(): Dynamic {
        this.calledFunction('createAccount', []);
        return Reflect.copy(this.accountList[0]);
    }


    public function getAccount(id: String): Dynamic {
        this.calledFunction('getAccount', [id]);
        var accounts = this.accountList.filter(function(account) { return account.id == id; });
        if (accounts.length > 0) {
            return Reflect.copy(accounts[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listAccountUsers(id: String): Array<Dynamic> {
        this.calledFunction('listAccountUsers', [id]);
        return this.userList.map(function(user) { return Reflect.copy(user); });
    }


    public function getAccountUser(id: String, userId: String): Dynamic {
        this.calledFunction('getAccountUser', [id, userId]);
        var users = this.userList.filter(function(user) { return user.id == userId; });
        if (users.length > 0) {
            return Reflect.copy(users[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listConversations(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listConversations', [filters]);
        return this.conversationList.map(function(conv) { return Reflect.copy(conv); });
    }


    public function createConversation(data: String): Dynamic {
        this.calledFunction('createConversation', [data]);
        var conv = Reflect.copy(this.conversationList[0]);
        var dataObj = haxe.Json.parse(data);
        var fields = Reflect.fields(dataObj);
        for (field in fields) {
            Reflect.setField(conv, field, Reflect.field(dataObj, field));
        }
        return conv;
    }


    public function getConversation(id: String): Dynamic {
        this.calledFunction('getConversation', [id]);
        var convs = this.conversationList.filter(function(conv) { return conv.id == id; });
        if (convs.length > 0) {
            return Reflect.copy(convs[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function createConversationMessage(id: String, data: String): Dynamic {
        this.calledFunction('createConversationMessage', [id, data]);
        var msg = Reflect.copy(this.conversationList[0].messages[0]);
        var dataObj = haxe.Json.parse(data);
        var fields = Reflect.fields(dataObj);
        for (field in fields) {
            Reflect.setField(msg, field, Reflect.field(dataObj, field));
        }
        return msg;
    }


    public function listProducts(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProducts', [filters]);
        return null;
    }


    public function getProduct(id: String): Dynamic {
        this.calledFunction('getProduct', [id]);
        return null;
    }


    public function listProductActions(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductActions', [id, filters]);
        return null;
    }


    public function getProductAction(id: String, actionId: String): Dynamic {
        this.calledFunction('getProductAction', [id, actionId]);
        return null;
    }


    public function getProductActionLink(id: String, actionId: String): Dynamic {
        this.calledFunction('getProductActionLink', [id, actionId]);
        return null;
    }


    public function getProductConnections(id: String): Array<Dynamic> {
        this.calledFunction('getProductConnections', [id]);
        return null;
    }


    public function getProductItems(id: String): Array<Dynamic> {
        this.calledFunction('getProductItems', [id]);
        return null;
    }


    public function getProductParameters(id: String): Array<Dynamic> {
        this.calledFunction('getProductParameters', [id]);
        return null;
    }


    public function getProductTemplates(id: String): Array<Dynamic> {
        this.calledFunction('getProductTemplates', [id]);
        return null;
    }


    public function getProductVersions(id: String): Array<Dynamic> {
        this.calledFunction('getProductVersions', [id]);
        return null;
    }


    public function getProductVersion(id: String, version: String): Dynamic {
        this.calledFunction('getProductVersion', [id, version]);
        return null;
    }


    public function getProductVersionActions(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionActions', [id, version]);
        return null;
    }


    public function getProductVersionAction(id: String, version: String,
            actionId: String): Dynamic {
        this.calledFunction('getProductVersionAction', [id, version]);
        return null;
    }
    

    public function getProductVersionActionLink(id: String, version: String,
            actionId: String): Dynamic {
        this.calledFunction('getProductVersionActionLink', [id, version]);
        return null;
    }


    public function getProductVersionItems(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionItems', [id, version]);
        return null;
    }


    public function getProductVersionParameters(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionParameters', [id, version]);
        return null;
    }


    public function getProductVersionTemplates(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionTemplates', [id, version]);
        return null;
    }


    public function listProductConfigurations(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductConfigurations', [id, filters]);
        return null;
    }


    public function setProductConfigurationParam(id: String, param: String): Dynamic {
        this.calledFunction('setProductConfigurationParam', [id, param]);
        return null;
    }


    public function listProductAgreements(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductAgreements', [id, filters]);
        return null;
    }


    public function listProductMedia(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductMedia', [id, filters]);
        return null;
    }


    public function createProductMedia(id: String): Dynamic {
        this.calledFunction('createProductMedia', [id]);
        return null;
    }


    public function getProductMedia(id: String, mediaId: String): Dynamic {
        this.calledFunction('getProductMedia', [id, mediaId]);
        return null;
    }


    public function updateProductMedia(id: String, mediaId: String, media: String): Dynamic {
        this.calledFunction('updateProductMedia', [id, mediaId, media]);
        return null;
    }


    public function deleteProductMedia(id: String, mediaId: String): Dynamic {
        this.calledFunction('deleteProductMedia', [id, mediaId]);
        return null;
    }


    public function listCategories(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listCategories', [filters]);
        return null;
    }


    public function getCategory(id: String): Dynamic {
        this.calledFunction('getCategory', [id]);
        return null;
    }


    private var accountList: Array<Dynamic>;
    private var conversationList: Array<Dynamic>;
    private var userList: Array<Dynamic>;
}
