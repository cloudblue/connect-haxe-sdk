package tests.mocks;

import connect.api.IGeneralApi;
import connect.api.QueryParams;


class GeneralApiMock extends Mock implements IGeneralApi {
    public function new() {
        super();
        this.accountList = Mock.parseJsonFile('tests/mocks/data/account_list.json');
        this.actionList = Mock.parseJsonFile('tests/mocks/data/action_list.json');
        this.agreementList = Mock.parseJsonFile('tests/mocks/data/agreement_list.json');
        this.categoryList = Mock.parseJsonFile('tests/mocks/data/category_list.json');
        this.configurationList = Mock.parseJsonFile('tests/mocks/data/configuration_list.json');
        this.connectionList = Mock.parseJsonFile('tests/mocks/data/connection_list.json');
        this.conversationList = Mock.parseJsonFile('tests/mocks/data/conversation_list.json');
        this.itemList = Mock.parseJsonFile('tests/mocks/data/item_list.json');
        this.mediaList = Mock.parseJsonFile('tests/mocks/data/media_list.json');
        this.paramList = Mock.parseJsonFile('tests/mocks/data/param_list.json');
        this.productList = Mock.parseJsonFile('tests/mocks/data/product_list.json');
        this.templateList = Mock.parseJsonFile('tests/mocks/data/template_list.json');
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
        return this.productList.map(function(product) { return Reflect.copy(product); });
    }


    public function getProduct(id: String): Dynamic {
        this.calledFunction('getProduct', [id]);
        var products = this.productList.filter(function(product) { return product.id == id; });
        if (products.length > 0) {
            return Reflect.copy(products[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listProductActions(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductActions', [id, filters]);
        return this.actionList.map(function(action) { return Reflect.copy(action); });
    }


    public function getProductAction(id: String, actionId: String): Dynamic {
        this.calledFunction('getProductAction', [id, actionId]);
        var actions = this.actionList.filter(function(action) { return action.id == id; });
        if (actions.length > 0) {
            return Reflect.copy(actions[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductActionLink(id: String, actionId: String): String {
        this.calledFunction('getProductActionLink', [id, actionId]);
        var action = this.getProductAction(id, actionId);
        if (action != null) {
            return 'https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi';
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductConnections(id: String): Array<Dynamic> {
        this.calledFunction('getProductConnections', [id]);
        if (this.getProduct(id) != null) {
            return this.connectionList.map(function(connection) {
                return Reflect.copy(connection);
            });
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductItems(id: String): Array<Dynamic> {
        this.calledFunction('getProductItems', [id]);
        if (this.getProduct(id) != null) {
            return this.itemList.map(function(item) { return Reflect.copy(item); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductParameters(id: String): Array<Dynamic> {
        this.calledFunction('getProductParameters', [id]);
        if (this.getProduct(id) != null) {
            return this.paramList.map(function(param) { return Reflect.copy(param); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductTemplates(id: String): Array<Dynamic> {
        this.calledFunction('getProductTemplates', [id]);
        if (this.getProduct(id) != null) {
            return this.templateList.map(function(template) { return Reflect.copy(template); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function listProductVersions(id: String): Array<Dynamic> {
        this.calledFunction('listProductVersions', [id]);
        if (this.getProduct(id) != null) {
            return this.productList.map(function(product) { return Reflect.copy(product); });
        } else {
            return [];
        }
    }


    public function getProductVersion(id: String, version: String): Dynamic {
        this.calledFunction('getProductVersion', [id, version]);
        var product = this.getProduct(id);
        if (product != null && product.version == version) {
            return product;
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionActions(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionActions', [id, version]);
        var product = this.getProduct(id);
        if (product != null && product.version == version) {
            return this.actionList.map(function(action) { return Reflect.copy(action); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionAction(id: String, version: String,
            actionId: String): Dynamic {
        this.calledFunction('getProductVersionAction', [id, version]);
        return this.getProductVersionActions(id, version).filter(function(action) {
            return action.id == actionId;
        })[0];
    }
    

    public function getProductVersionActionLink(id: String, version: String,
            actionId: String): String {
        this.calledFunction('getProductVersionActionLink', [id, version]);
        if (this.getProductVersionAction(id, version, actionId)) {
            return 'https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi';
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionItems(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionItems', [id, version]);
        if (this.getProductVersion(id, version)) {
            return this.getProductItems(id);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionParameters(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionParameters', [id, version]);
        if (this.getProductVersion(id, version)) {
            return this.getProductParameters(id);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionTemplates(id: String, version: String): Array<Dynamic> {
        this.calledFunction('getProductVersionTemplates', [id, version]);
        if (this.getProductVersion(id, version)) {
            return this.getProductTemplates(id);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listProductConfigurations(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductConfigurations', [id, filters]);
        if (this.getProduct(id) != null) {
            return this.configurationList.map(function(conf) { return Reflect.copy(conf); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function setProductConfigurationParam(id: String, param: String): Dynamic {
        this.calledFunction('setProductConfigurationParam', [id, param]);
        if (this.getProduct(id) != null) {
            return haxe.Json.parse(param);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listProductAgreements(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductAgreements', [id, filters]);
        if (this.getProduct(id) != null) {
            return this.agreementList.map(function(agreement) { return Reflect.copy(agreement); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function listProductMedia(id: String, ?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listProductMedia', [id, filters]);
        if (this.getProduct(id) != null) {
            return this.mediaList.map(function(media) { return Reflect.copy(media); });
        } else {
            throw 'Http Error #404';
        }
    }


    public function createProductMedia(id: String): Dynamic {
        this.calledFunction('createProductMedia', [id]);
        return Reflect.copy(this.mediaList[0]);
    }


    public function getProductMedia(id: String, mediaId: String): Dynamic {
        this.calledFunction('getProductMedia', [id, mediaId]);
        if (this.getProduct(id) != null) {
            var media = this.mediaList.filter(function(media) { return media.id == mediaId; });
            if (media.length > 0) {
                return media[0];
            } else {
                throw 'Http Error #404';
            }
        } else {
            throw 'Http Error #404';
        }
    }


    public function updateProductMedia(id: String, mediaId: String, media: String): Dynamic {
        this.calledFunction('updateProductMedia', [id, mediaId, media]);
        if (this.getProductMedia(id, mediaId) != null) {
            return haxe.Json.parse(media);
        } else {
            throw 'Http Error #404';
        }
    }


    public function deleteProductMedia(id: String, mediaId: String): Dynamic {
        this.calledFunction('deleteProductMedia', [id, mediaId]);
        return haxe.Json.parse(this.getProductMedia(id, mediaId));
    }


    public function listCategories(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listCategories', [filters]);
        return this.categoryList.map(function(cat) { return Reflect.copy(cat); });
    }


    public function getCategory(id: String): Dynamic {
        this.calledFunction('getCategory', [id]);
        var categories = this.categoryList.filter(function(cat) { return cat.id == id; });
        if (categories.length > 0) {
            return Reflect.copy(categories[0]);
        } else {
            throw 'Http Error #404';
        }
        return null;
    }


    private var accountList: Array<Dynamic>;
    private var actionList: Array<Dynamic>;
    private var agreementList: Array<Dynamic>;
    private var categoryList: Array<Dynamic>;
    private var configurationList: Array<Dynamic>;
    private var connectionList: Array<Dynamic>;
    private var conversationList: Array<Dynamic>;
    private var itemList: Array<Dynamic>;
    private var mediaList: Array<Dynamic>;
    private var paramList: Array<Dynamic>;
    private var productList: Array<Dynamic>;
    private var templateList: Array<Dynamic>;
    private var userList: Array<Dynamic>;
}
