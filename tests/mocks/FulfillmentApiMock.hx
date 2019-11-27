package tests.mocks;

import connect.api.IFulfillmentApi;
import connect.api.Query;
import haxe.Json;


class FulfillmentApiMock extends Mock implements IFulfillmentApi {
    public function new() {
        super();
        this.list = Mock.parseJsonFile('tests/mocks/data/request_list.json');
    }


    public function listRequests(filters: Query): String {
        this.calledFunction('listRequests', [filters]);
        return Json.stringify(this.list);
    }


    public function getRequest(id: String): String {
        this.calledFunction('getRequest', [id]);
        final requests = this.list.filter((request) -> request.id == id);
        if (requests.length > 0) {
            return Json.stringify(requests[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function createRequest(body: String): String {
        this.calledFunction('createRequest', [body]);
        return Json.stringify(this.list[0]);
    }


    public function updateRequest(id: String, request: String): String {
        this.calledFunction('updateRequest', [id, request]);
        return this.getRequest(id);
    }


    public function changeRequestStatus(id: String, status: String, data: String): String {
        this.calledFunction('changeRequestStatus', [id, status, data]);
        final request = Json.parse(this.getRequest(id));
        request.status = status;
        return Json.stringify(request);
    }


    public function assignRequest(id: String, assignee: String): String {
        this.calledFunction('assignRequest', [id, assignee]);
        final request = Json.parse(this.getRequest(id));
        request.assignee = assignee;
        return Json.stringify(request);
    }


    public function renderTemplate(id: String, request_id: String): String {
        this.calledFunction('renderTemplate', [id, request_id]);
        return '';
    }


    public function listAssets(filters: Query): String {
        this.calledFunction('listAssets', [filters]);
        return Json.stringify(this.list.map((request) -> request.asset));
    }


    public function getAsset(id: String): String {
        this.calledFunction('getAsset', [id]);
        final assets: Array<Dynamic> = Json.parse(this.listAssets(null))
            .filter((asset) -> asset.id == id);
        if (assets.length > 0) {
            return Json.stringify(assets[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function getAssetRequests(id: String): String {
        this.calledFunction('getAssetRequests', [id]);
        return Json.stringify(this.list.filter((request) -> request.asset.id == id));
    }


    private final list: Array<Dynamic>;
}
