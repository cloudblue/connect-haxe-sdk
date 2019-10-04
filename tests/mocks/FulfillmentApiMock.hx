package tests.mocks;

import connect.api.IFulfillmentApi;
import connect.api.QueryParams;


class FulfillmentApiMock extends Mock implements IFulfillmentApi {
    public function new() {
        super();
        this.list = Mock.parseJsonFile('tests/mocks/data/fulfillment_list.json');
    }


    public function listRequests(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listRequests', [filters]);
        return this.list.copy();
    }


    public function getRequest(id: String): Dynamic {
        this.calledFunction('getRequest', [id]);
        var requests = this.list.filter(function(request) { return request.id == id; });
        if (requests.length > 0) {
            return Reflect.copy(requests[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function createRequest(): Dynamic {
        this.calledFunction('createRequest', []);
        return this.list[0];
    }


    public function updateRequest(id: String, request: String): Dynamic {
        this.calledFunction('updateRequest', [id, request]);
        return this.getRequest(id);
    }


    public function changeRequestStatus(id: String, status: String, data: String): Dynamic {
        this.calledFunction('changeRequestStatus', [id, status, data]);
        var request = this.getRequest(id);
        request.status = status;
        return request;
    }


    public function assignRequest(id: String, assignee: String): Dynamic {
        this.calledFunction('assignRequest', [id, assignee]);
        var request = this.getRequest(id);
        request.assignee = assignee;
        return request;
    }


    public function renderTemplate(id: String, request_id: String): String {
        this.calledFunction('renderTemplate', [id, request_id]);
        return '';
    }


    public function listAssets(?filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listAssets', [filters]);
        return null;
    }


    public function getAsset(id: String): Dynamic {
        this.calledFunction('getAsset', [id]);
        return null;
    }


    public function getAssetRequests(id: String): Array<Dynamic> {
        this.calledFunction('getAssetRequests', [id]);
        return null;
    }


    private var list: Array<Dynamic>;
}
