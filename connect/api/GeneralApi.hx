package connect.api;

class GeneralApi {
    private static inline var ACCOUNTS_PATH = 'accounts';
    private static inline var CONVERSATIONS_PATH = 'conversations';
    private static inline var PRODUCTS_PATH = 'products';
    private static inline var CATEGORIES_PATH = 'categories';

    private var client: IApiClient;


    public function new(?client: IApiClient) {
        this.client = client != null ? client : ApiClient.getInstance();
    }


    public function listAccounts(?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(ACCOUNTS_PATH, null, null, filters));
    }


    public function createAccount(): Dynamic {
        return this.client.post(ACCOUNTS_PATH);
    }


    public function getAccount(id: String): Dynamic {
        return this.client.get(ACCOUNTS_PATH, id);
    }


    public function listAccountUsers(id: String): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(ACCOUNTS_PATH, id, 'users'));
    }


    public function getAccountUser(id: String, userId: String): Dynamic {
        return this.client.get(ACCOUNTS_PATH, id, 'users/${userId}');
    }


    public function createConversation(data: Dynamic): Dynamic {
        return this.client.post(CONVERSATIONS_PATH, null, null, data);
    }


    public function getConversation(id: String): Dynamic {
        return this.client.get(CONVERSATIONS_PATH, id);
    }


    public function createConversationMessage(id: String, data: Dynamic): Dynamic {
        return this.client.post(CONVERSATIONS_PATH, id, 'messages', data);
    }


    public function listProducts(?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, null, null, filters));
    }


    public function getProduct(id: String): Dynamic {
        return this.client.get(PRODUCTS_PATH, id);
    }


    public function listProductActions(id: String, ?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'actions', filters));
    }


    public function getProductAction(id: String, actionId: String): Dynamic {
        return this.client.get(PRODUCTS_PATH, id, 'actions/${actionId}');
    }


    public function getProductActionLink(id: String, actionId: String): Dynamic {
        return this.client.get(PRODUCTS_PATH, id, 'actions/${actionId}/actionLink');
    }


    public function getProductConnections(id: String): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'connections'));
    }


    public function getProductItems(id: String): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'items'));
    }


    public function getProductParameters(id: String): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'parameters'));
    }


    public function getProductTemplates(id: String): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'templates'));
    }


    public function getProductVersions(id: String): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'versions'));
    }


    public function getProductVersion(id: String, version: String): Dynamic {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'versions/${version}'));
    }


    public function getProductVersionActions(id: String, version: String): Collection<Dynamic> {
        return new Collection<Dynamic>(
            this.client.get(PRODUCTS_PATH, id, 'versions/${version}/actions'));
    }


    public function getProductVersionAction(id: String, version: String,
            actionId: String): Dynamic {
        return this.client.get(PRODUCTS_PATH, id,
            'versions/${version}/actions/${actionId}');
    }


    public function getProductVersionActionLink(id: String, version: String,
            actionId: String): Dynamic {
        return this.client.get(PRODUCTS_PATH, id,
            'versions/${version}/actions/${actionId}/actionLink');
    }


    public function getProductVersionItems(id: String, version: String): Collection<Dynamic> {
        return new Collection<Dynamic>(
            this.client.get(PRODUCTS_PATH, id, 'versions/${version}/items'));
    }


    public function getProductVersionParameters(id: String, version: String): Collection<Dynamic> {
        return new Collection<Dynamic>(
            this.client.get(PRODUCTS_PATH, id, 'versions/${version}/parameters'));
    }


    public function getProductVersionTemplates(id: String, version: String): Collection<Dynamic> {
        return new Collection<Dynamic>(
            this.client.get(PRODUCTS_PATH, id, 'versions/${version}/templates'));
    }


    public function listProductConfigurations(id: String, ?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(
            this.client.get(PRODUCTS_PATH, id, 'configurations', filters));
    }


    public function setProductConfigurationParam(id: String, param: Dynamic): Dynamic {
        return this.client.post(PRODUCTS_PATH, id, 'configurations', param);
    }


    public function listProductAgreements(id: String, ?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'agreements', filters));
    }


    public function listProductMedia(id: String, ?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(PRODUCTS_PATH, id, 'media', filters));
    }


    public function createProductMedia(id: String): Dynamic {
        return this.client.post(PRODUCTS_PATH, id, 'media');
    }


    public function getProductMedia(id: String, mediaId: String): Dynamic {
        return this.client.post(PRODUCTS_PATH, id, 'media/${mediaId}');
    }


    public function updateProductMedia(id: String, mediaId: String, media: Dynamic): Dynamic {
        return this.client.put(PRODUCTS_PATH, '${id}/media/${mediaId}', media);
    }


    public function deleteProductMedia(id: String, mediaId: String): Dynamic {
        return this.client.delete(PRODUCTS_PATH, id, 'media/${mediaId}');
    }


    public function listCategories(?filters: QueryParams): Collection<Dynamic> {
        return new Collection<Dynamic>(this.client.get(CATEGORIES_PATH, null, null, filters));
    }


    public function getCategory(id: String): Dynamic {
        return this.client.get(CATEGORIES_PATH, id);
    }
}
