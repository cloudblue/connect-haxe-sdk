package connect.api.impl;


class GeneralApiImpl implements IGeneralApi {
    private static inline var ACCOUNTS_PATH = 'accounts';
    private static inline var CONVERSATIONS_PATH = 'conversations';
    private static inline var PRODUCTS_PATH = 'products';
    private static inline var CATEGORIES_PATH = 'categories';


    public function new() {}


    public function listAccounts(filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(ACCOUNTS_PATH, null, null, filters);
    }


    public function createAccount(): Dynamic {
        return Environment.getApiClient().post(ACCOUNTS_PATH);
    }


    public function getAccount(id: String): Dynamic {
        return Environment.getApiClient().get(ACCOUNTS_PATH, id);
    }


    public function listAccountUsers(id: String): Array<Dynamic> {
        return Environment.getApiClient().get(ACCOUNTS_PATH, id, 'users');
    }


    public function getAccountUser(id: String, userId: String): Dynamic {
        return Environment.getApiClient().get(ACCOUNTS_PATH, id, 'users/${userId}');
    }


    public function listConversations(filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(CONVERSATIONS_PATH, null, null, filters);
    }


    public function createConversation(data: String): Dynamic {
        return Environment.getApiClient().post(CONVERSATIONS_PATH, null, null, data);
    }


    public function getConversation(id: String): Dynamic {
        return Environment.getApiClient().get(CONVERSATIONS_PATH, id);
    }


    public function createConversationMessage(id: String, data: String): Dynamic {
        return Environment.getApiClient().post(CONVERSATIONS_PATH, id, 'messages', data);
    }


    public function listProducts(filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, null, null, filters);
    }


    public function getProduct(id: String): Dynamic {
        return Environment.getApiClient().get(PRODUCTS_PATH, id);
    }


    public function listProductActions(id: String, filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'actions', filters);
    }


    public function getProductAction(id: String, actionId: String): Dynamic {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'actions/${actionId}');
    }


    public function getProductActionLink(id: String, actionId: String): String {
        return Environment.getApiClient()
            .get(PRODUCTS_PATH, id, 'actions/${actionId}/actionLink')
            .link;
    }


    public function getProductConnections(id: String): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'connections');
    }


    public function getProductItems(id: String): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'items');
    }


    public function getProductParameters(id: String): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'parameters');
    }


    public function getProductTemplates(id: String): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'templates');
    }


    public function getProductVersions(id: String): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'versions');
    }


    public function getProductVersion(id: String, version: Int): Dynamic {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'versions/${version}');
    }


    public function getProductVersionActions(id: String, version: Int): Array<Dynamic> {
        return 
            Environment.getApiClient().get(PRODUCTS_PATH, id, 'versions/${version}/actions');
    }


    public function getProductVersionAction(id: String, version: Int,
            actionId: String): Dynamic {
        return Environment.getApiClient().get(PRODUCTS_PATH, id,
            'versions/${version}/actions/${actionId}');
    }


    public function getProductVersionActionLink(id: String, version: Int,
            actionId: String): String {
        return Environment.getApiClient()
            .get(PRODUCTS_PATH, id, 'versions/${version}/actions/${actionId}/actionLink')
            .link;
    }


    public function getProductVersionItems(id: String, version: Int): Array<Dynamic> {
        return 
            Environment.getApiClient().get(PRODUCTS_PATH, id, 'versions/${version}/items');
    }


    public function getProductVersionParameters(id: String, version: Int): Array<Dynamic> {
        return 
            Environment.getApiClient().get(PRODUCTS_PATH, id, 'versions/${version}/parameters');
    }


    public function getProductVersionTemplates(id: String, version: Int): Array<Dynamic> {
        return 
            Environment.getApiClient().get(PRODUCTS_PATH, id, 'versions/${version}/templates');
    }


    public function listProductConfigurations(id: String, filters: QueryParams): Array<Dynamic> {
        return 
            Environment.getApiClient().get(PRODUCTS_PATH, id, 'configurations', filters);
    }


    public function setProductConfigurationParam(id: String, param: String): Dynamic {
        return Environment.getApiClient().post(PRODUCTS_PATH, id, 'configurations', param);
    }


    public function listProductAgreements(id: String, filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'agreements', filters);
    }


    public function listProductMedia(id: String, filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(PRODUCTS_PATH, id, 'media', filters);
    }


    public function createProductMedia(id: String): Dynamic {
        return Environment.getApiClient().post(PRODUCTS_PATH, id, 'media');
    }


    public function getProductMedia(id: String, mediaId: String): Dynamic {
        return Environment.getApiClient().post(PRODUCTS_PATH, id, 'media/${mediaId}');
    }


    public function updateProductMedia(id: String, mediaId: String, media: String): Dynamic {
        return Environment.getApiClient().put(PRODUCTS_PATH, '${id}/media/${mediaId}', media);
    }


    public function deleteProductMedia(id: String, mediaId: String): Dynamic {
        return Environment.getApiClient().delete(PRODUCTS_PATH, id, 'media/${mediaId}');
    }


    public function listCategories(filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(CATEGORIES_PATH, null, null, filters);
    }


    public function getCategory(id: String): Dynamic {
        return Environment.getApiClient().get(CATEGORIES_PATH, id);
    }
}
