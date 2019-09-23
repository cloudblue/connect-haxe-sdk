package connect.api;


class FulfillmentApi {
    private static inline var RESOURCE = 'requests';


    public function new() {}


    public function listRequests(?filters: QueryParams): Array<Dynamic> {
        return ApiClient.getInstance().list(RESOURCE, filters);
    }


    public function getRequest(id: String): Dynamic {
        return ApiClient.getInstance().get(RESOURCE, id);
    }


    public function createRequest(): Dynamic {
        return ApiClient.getInstance().post(RESOURCE);
    }


    public function updateRequest(request: Dynamic): Dynamic {
        return ApiClient.getInstance().put(RESOURCE, request.id, request);
    }


    public function changeRequestStatus(id: String, status: String, data: Dynamic): Dynamic {
        return ApiClient.getInstance().post(RESOURCE, id, status, data);
    }


    public function assignRequest(id: String, assignee: String): Dynamic {
        return ApiClient.getInstance().post(RESOURCE, id, 'assign/' + assignee);
    }
}
