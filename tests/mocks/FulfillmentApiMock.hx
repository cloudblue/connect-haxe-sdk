package tests.mocks;

import connect.api.IFulfillmentApi;
import connect.api.QueryParams;


class FulfillmentApiMock extends Mock implements IFulfillmentApi {
    public function new() {
        super();
        this.list = Mock.parseJsonFile('tests/mocks/data/request_list.json');
    }


    public function listRequests(filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listRequests', [filters]);
        return this.list.map(function(request) { return Reflect.copy(request); });
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
        return Reflect.copy(this.list[0]);
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


    public function listAssets(filters: QueryParams): Array<Dynamic> {
        this.calledFunction('listAssets', [filters]);
        var requests = this.listRequests(filters);
        return requests.map(function (request) { return Reflect.copy(request.asset); });
    }


    public function getAsset(id: String): Dynamic {
        this.calledFunction('getAsset', [id]);
        var assets = this.listAssets(null).filter(function(asset) { return asset.id == id; });
        if (assets.length > 0) {
            return Reflect.copy(assets[0]);
        } else {
            throw 'Http Error #404';
        }
        return null;
    }


    public function getAssetRequests(id: String): Array<Dynamic> {
        this.calledFunction('getAssetRequests', [id]);
        return this.listRequests(null)
            .filter(function(request) { return request.asset.id == id; })
            .map(function(request) { return Reflect.copy(request); });
    }


    private var list: Array<Dynamic>;
}
