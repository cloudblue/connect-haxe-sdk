package connect.api;


interface IFulfillmentApi {
    public function listRequests(?filters: QueryParams): Array<Dynamic>;
    public function getRequest(id: String): Dynamic;
    public function createRequest(): Dynamic;
    public function updateRequest(id: String, request: String): Dynamic;
    public function changeRequestStatus(id: String, status: String, data: String): Dynamic;
    public function assignRequest(id: String, assignee: String): Dynamic;
    public function renderTemplate(id: String, request_id: String): String;
    public function listAssets(?filters: QueryParams): Array<Dynamic>;
    public function getAsset(id: String): Dynamic;
    public function getAssetRequests(id: String): Array<Dynamic>;
}
