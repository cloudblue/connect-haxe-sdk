package connect.api;

interface IGeneralApi {
    public function listAccounts(?filters: QueryParams): Array<Dynamic>;
    public function createAccount(): Dynamic;
    public function getAccount(id: String): Dynamic;
    public function listAccountUsers(id: String): Array<Dynamic>;
    public function getAccountUser(id: String, userId: String): Dynamic;
    public function listConversations(?filters: QueryParams): Array<Dynamic>;
    public function createConversation(data: String): Dynamic;
    public function getConversation(id: String): Dynamic;
    public function createConversationMessage(id: String, data: String): Dynamic;
    public function listProducts(?filters: QueryParams): Array<Dynamic>;
    public function getProduct(id: String): Dynamic;
    public function listProductActions(id: String, ?filters: QueryParams): Array<Dynamic>;
    public function getProductAction(id: String, actionId: String): Dynamic;
    public function getProductActionLink(id: String, actionId: String): String;
    public function getProductConnections(id: String): Array<Dynamic>;
    public function getProductItems(id: String): Array<Dynamic>;
    public function getProductParameters(id: String): Array<Dynamic>;
    public function getProductTemplates(id: String): Array<Dynamic>;
    public function listProductVersions(id: String): Array<Dynamic>;
    public function getProductVersion(id: String, version: String): Dynamic;
    public function getProductVersionActions(id: String, version: String): Array<Dynamic>;
    public function getProductVersionAction(id: String, version: String,
            actionId: String): Dynamic;
    public function getProductVersionActionLink(id: String, version: String,
            actionId: String): String;
    public function getProductVersionItems(id: String, version: String): Array<Dynamic>;
    public function getProductVersionParameters(id: String, version: String): Array<Dynamic>;
    public function getProductVersionTemplates(id: String, version: String): Array<Dynamic>;
    public function listProductConfigurations(id: String, ?filters: QueryParams): Array<Dynamic>;
    public function setProductConfigurationParam(id: String, param: String): Dynamic;
    public function listProductAgreements(id: String, ?filters: QueryParams): Array<Dynamic>;
    public function listProductMedia(id: String, ?filters: QueryParams): Array<Dynamic>;
    public function createProductMedia(id: String): Dynamic;
    public function getProductMedia(id: String, mediaId: String): Dynamic;
    public function updateProductMedia(id: String, mediaId: String, media: String): Dynamic;
    public function deleteProductMedia(id: String, mediaId: String): Dynamic;
    public function listCategories(?filters: QueryParams): Array<Dynamic>;
    public function getCategory(id: String): Dynamic;
}
