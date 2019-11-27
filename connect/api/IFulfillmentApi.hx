package connect.api;


@:dox(hide)
interface IFulfillmentApi {
    public function listRequests(filters: Query): String;
    public function getRequest(id: String): String;
    public function createRequest(body: String): String;
    public function updateRequest(id: String, request: String): String;
    public function changeRequestStatus(id: String, status: String, data: String): String;
    public function assignRequest(id: String, assignee: String): String;
    public function renderTemplate(id: String, request_id: String): String;
    public function listAssets(filters: Query): String;
    public function getAsset(id: String): String;
    public function getAssetRequests(id: String): String;
}
