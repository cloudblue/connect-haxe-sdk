package connect.models;

import connect.api.IFulfillmentApi;
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


    public static function list(?filters: QueryParams, ?api: IFulfillmentApi)
            : Collection<Fulfillment> {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var requests = api.listRequests(filters);
        return Model.parseArray(Fulfillment, requests);
    }


    public static function get(id: String, ?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.getRequest(id);
        return Model.parse(Fulfillment, request);
    }


    public static function create(?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.createRequest();
        return Model.parse(Fulfillment, request);
    }


    public function update(?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.updateRequest(
            this.id,
            this.toString());
        return Model.parse(Fulfillment, request);
    }


    public function approveByTemplate(id: String, ?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({template_id: id})
        );
        return Model.parse(Fulfillment, request);
    }


    public function approveByTile(text: String, ?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({activation_tile: text})
        );
        return Model.parse(Fulfillment, request);
    }


    public function fail(reason: String, ?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.changeRequestStatus(
            this.id,
            'fail',
            haxe.Json.stringify({reason: reason})
        );
        return Model.parse(Fulfillment, request);
    }


    public function inquire(?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.changeRequestStatus(
            this.id,
            'inquire',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    public function pend(?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
        var request = api.changeRequestStatus(
            this.id,
            'pend',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    public function assignTo(assignee_id: String, ?api: IFulfillmentApi): Fulfillment {
        api = (api != null) ? api : Defaults.getConnectApi().fulfillment;
       var request = api.assignRequest(
            this.id,
            assignee_id
        );
        return Model.parse(Fulfillment, request);
    }


    public function new() {
        this._setFieldClassNames([
            'assignee' => 'User'
        ]);
    }
}
