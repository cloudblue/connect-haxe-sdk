package connect.models;

import connect.api.ConnectApi;
import connect.api.QueryParams;


class Fulfillment extends IdModel {
    public var type(default, null): String;
    public var created(default, null): String;
    public var updated(default, null): String;
    public var status(default, null): String;
    public var paramsFormUrl(default, null): String;
    public var activationKey(default, null): String;
    public var reason(default, null): String;
    public var note(default, null): String;
    public var asset(default, null): Asset;
    public var contract(default, null): Contract;
    public var marketplace(default, null): Marketplace;
    //public var assignee(default, null): User;


    public function new() {
        this._setFieldClassNames([
            'assignee' => 'User'
        ]);
    }

    public static function list(?filters: QueryParams): Collection<Fulfillment> {
        var requests = ConnectApi.getInstance().fulfillment.listRequests(filters);
        return Model.parseCollection(Fulfillment, requests);
    }


    public static function get(id: String): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.getRequest(id);
        return Model.parse(Fulfillment, request);
    }


    public static function create(): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.createRequest();
        return Model.parse(Fulfillment, request);
    }


    public function update(): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.updateRequest(
            this.id,
            this.toDictionary());
        return Model.parse(Fulfillment, request);
    }


    /*
    public function approve(approval: IApproval): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'approve',
            approval
        );
        return Model.parse(Fulfillment, request);
    }


    public function fail(): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'fail'
        );
        return Model.parse(Fulfillment, request);
    }
    */
}
