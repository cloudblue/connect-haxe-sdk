package tests.mocks;

import connect.api.IGeneralApi;
import connect.api.Query;
import haxe.Json;


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


    public function listAccounts(filters: Query): String {
        this.calledFunction('listAccounts', [filters]);
        return Json.stringify(this.accountList);
    }


    public function createAccount(): String {
        this.calledFunction('createAccount', []);
        return Json.stringify(this.accountList[0]);
    }


    public function getAccount(id: String): String {
        this.calledFunction('getAccount', [id]);
        final accounts = this.accountList.filter((account) -> account.id == id);
        if (accounts.length > 0) {
            return Json.stringify(accounts[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listAccountUsers(id: String): String {
        this.calledFunction('listAccountUsers', [id]);
        return Json.stringify(this.userList);
    }


    public function getAccountUser(id: String, userId: String): String {
        this.calledFunction('getAccountUser', [id, userId]);
        final users = this.userList.filter((user) -> user.id == userId);
        if (users.length > 0) {
            return Json.stringify(users[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listConversations(filters: Query): String {
        this.calledFunction('listConversations', [filters]);
        return Json.stringify(this.conversationList);
    }


    public function createConversation(data: String): String {
        this.calledFunction('createConversation', [data]);
        final conv = Reflect.copy(this.conversationList[0]);
        final dataObj = Json.parse(data);
        for (field in Reflect.fields(dataObj)) {
            Reflect.setField(conv, field, Reflect.field(dataObj, field));
        }
        return Json.stringify(conv);
    }


    public function getConversation(id: String): String {
        this.calledFunction('getConversation', [id]);
        final convs = this.conversationList.filter((conv) -> conv.id == id);
        if (convs.length > 0) {
            return Json.stringify(convs[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function createConversationMessage(id: String, data: String): String {
        this.calledFunction('createConversationMessage', [id, data]);
        final msg = Reflect.copy(this.conversationList[0].messages[0]);
        final dataObj = Json.parse(data);
        for (field in Reflect.fields(dataObj)) {
            Reflect.setField(msg, field, Reflect.field(dataObj, field));
        }
        return Json.stringify(msg);
    }


    public function listProducts(filters: Query): String {
        this.calledFunction('listProducts', [filters]);
        return Json.stringify(this.productList);
    }


    public function getProduct(id: String): String {
        this.calledFunction('getProduct', [id]);
        final products = this.productList.filter((product) -> product.id == id);
        if (products.length > 0) {
            return Json.stringify(products[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listProductActions(id: String, filters: Query): String {
        this.calledFunction('listProductActions', [id, filters]);
        this.getProduct(id);
        return Json.stringify(this.actionList);
    }


    public function getProductAction(id: String, actionId: String): String {
        this.calledFunction('getProductAction', [id, actionId]);
        this.getProduct(id);
        final actions = this.actionList.filter((action) -> action.id == actionId);
        if (actions.length > 0) {
            return Json.stringify(actions[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductActionLink(id: String, actionId: String): String {
        this.calledFunction('getProductActionLink', [id, actionId]);
        this.getProductAction(id, actionId);
        return 'https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi';
    }


    public function getProductConnections(id: String): String {
        this.calledFunction('getProductConnections', [id]);
        this.getProduct(id);
        return Json.stringify(this.connectionList);
    }


    public function getProductItems(id: String): String {
        this.calledFunction('getProductItems', [id]);
        this.getProduct(id);
        return Json.stringify(this.itemList);
    }


    public function getProductParameters(id: String): String {
        this.calledFunction('getProductParameters', [id]);
        this.getProduct(id);
        return Json.stringify(this.paramList);
    }


    public function getProductTemplates(id: String): String {
        this.calledFunction('getProductTemplates', [id]);
        this.getProduct(id);
        return Json.stringify(this.templateList);
    }


    public function getProductVersions(id: String): String {
        this.calledFunction('getProductVersions', [id]);
        this.getProduct(id);
        return Json.stringify(this.productList);
    }


    public function getProductVersion(id: String, version: Int): String {
        this.calledFunction('getProductVersion', [id, version]);
        final product = Json.parse(this.getProduct(id));
        if (product.version == version) {
            return Json.stringify(product);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionActions(id: String, version: Int): String {
        this.calledFunction('getProductVersionActions', [id, version]);
        final product = Json.parse(this.getProduct(id));
        if (product.version == version) {
            return Json.stringify(this.actionList);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getProductVersionAction(id: String, version: Int,
            actionId: String): String {
        this.calledFunction('getProductVersionAction', [id, version, actionId]);
        final actions = Json.parse(this.getProductVersionActions(id, version));
        final filtered: Array<Dynamic> = actions.filter((action) -> action.id == actionId);
        if (filtered.length > 0) {
            return Json.stringify(filtered[0]);
        } else {
            throw 'Http Error #404';
        }
    }
    

    public function getProductVersionActionLink(id: String, version: Int,
            actionId: String): String {
        this.calledFunction('getProductVersionActionLink', [id, version, actionId]);
        this.getProductVersionAction(id, version, actionId);
        return 'https://stub-dot-mydevball.appspot.com/?jwt=eyJhbGciOi';
    }


    public function getProductVersionItems(id: String, version: Int): String {
        this.calledFunction('getProductVersionItems', [id, version]);
        this.getProductVersion(id, version);
        return this.getProductItems(id);
    }


    public function getProductVersionParameters(id: String, version: Int): String {
        this.calledFunction('getProductVersionParameters', [id, version]);
        this.getProductVersion(id, version);
        return this.getProductParameters(id);
    }


    public function getProductVersionTemplates(id: String, version: Int): String {
        this.calledFunction('getProductVersionTemplates', [id, version]);
        this.getProductVersion(id, version);
        return this.getProductTemplates(id);
    }


    public function listProductConfigurations(id: String, filters: Query): String {
        this.calledFunction('listProductConfigurations', [id, filters]);
        this.getProduct(id);
        return Json.stringify(this.configurationList);
    }


    public function setProductConfigurationParam(id: String, param: String): String {
        this.calledFunction('setProductConfigurationParam', [id, param]);
        this.getProduct(id);
        return param;
    }


    public function listProductAgreements(id: String, filters: Query): String {
        this.calledFunction('listProductAgreements', [id, filters]);
        this.getProduct(id);
        return Json.stringify(this.agreementList);
    }


    public function listProductMedia(id: String, filters: Query): String {
        this.calledFunction('listProductMedia', [id, filters]);
        this.getProduct(id);
        return Json.stringify(this.mediaList);
    }


    public function createProductMedia(id: String): String {
        this.calledFunction('createProductMedia', [id]);
        this.getProduct(id);
        return Json.stringify(this.mediaList[0]);
    }


    public function getProductMedia(id: String, mediaId: String): String {
        this.calledFunction('getProductMedia', [id, mediaId]);
        this.getProduct(id);
        final media = this.mediaList.filter((media) -> media.id == mediaId);
        if (media.length > 0) {
            return Json.stringify(media[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function updateProductMedia(id: String, mediaId: String, media: String): String {
        this.calledFunction('updateProductMedia', [id, mediaId, media]);
        this.getProductMedia(id, mediaId);
        return media;
    }


    public function deleteProductMedia(id: String, mediaId: String): String {
        this.calledFunction('deleteProductMedia', [id, mediaId]);
        return this.getProductMedia(id, mediaId);
    }


    public function listCategories(filters: Query): String {
        this.calledFunction('listCategories', [filters]);
        return Json.stringify(this.categoryList);
    }


    public function getCategory(id: String): String {
        this.calledFunction('getCategory', [id]);
        final categories = this.categoryList.filter((cat) -> cat.id == id);
        if (categories.length > 0) {
            return Json.stringify(categories[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    private final accountList: Array<Dynamic>;
    private final actionList: Array<Dynamic>;
    private final agreementList: Array<Dynamic>;
    private final categoryList: Array<Dynamic>;
    private final configurationList: Array<Dynamic>;
    private final connectionList: Array<Dynamic>;
    private final conversationList: Array<Dynamic>;
    private final itemList: Array<Dynamic>;
    private final mediaList: Array<Dynamic>;
    private final paramList: Array<Dynamic>;
    private final productList: Array<Dynamic>;
    private final templateList: Array<Dynamic>;
    private final userList: Array<Dynamic>;
}
