package connect.api;


class FulfillmentApi {
    private static inline var REQUESTS_PATH = 'requests';
    private static inline var TEMPLATES_PATH = 'templates';
    private static inline var ASSETS_PATH = 'assets';

    private var client: IApiClient;


    public function new(?client: IApiClient) {
        this.client = client != null ? client : ApiClient.getInstance();
    }


    public function listRequests(?filters: QueryParams): Array<Dynamic> {
        return this.client.get(REQUESTS_PATH, null, null, filters);
    }


    public function getRequest(id: String): Dynamic {
        return this.client.get(REQUESTS_PATH, id);
    }


    public function createRequest(): Dynamic {
        return this.client.post(REQUESTS_PATH);
    }


    public function updateRequest(id: String, request: Dynamic): Dynamic {
        return this.client.put(REQUESTS_PATH, id, request);
    }


    public function changeRequestStatus(id: String, status: String, data: Dynamic): Dynamic {
        return this.client.post(REQUESTS_PATH, id, status, data);
    }


    public function assignRequest(id: String, assignee: String): Dynamic {
        return this.client.post(REQUESTS_PATH, id, 'assign/' + assignee);
    }


    public function renderTemplate(id: String, request_id: String): String {
        return this.client.get(TEMPLATES_PATH, id, 'render',
            new QueryParams().param('request_id', request_id), false);
    }


    public function listAssets(?filters: QueryParams): Array<Dynamic> {
        return this.client.get(ASSETS_PATH, null, null, filters);
    }


    public function getAsset(id: String): Dynamic {
        return this.client.get(ASSETS_PATH, id);
    }


    public function getAssetRequests(id: String): Array<Dynamic> {
        return this.client.get(ASSETS_PATH, id, 'requests');
    }
}
