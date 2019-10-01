package connect.models;

import connect.api.ConnectApi;
import connect.api.QueryParams;
import connect.Util;


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
        return Model.parseArray(Fulfillment, requests);
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
            this.toString());
        return Model.parse(Fulfillment, request);
    }


    public function approveByTemplate(id: String): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({template_id: id})
        );
        return Model.parse(Fulfillment, request);
    }


    public function approveByTile(text: String): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({activation_tile: text})
        );
        return Model.parse(Fulfillment, request);
    }


    public function fail(reason: String): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'fail',
            haxe.Json.stringify({reason: reason})
        );
        return Model.parse(Fulfillment, request);
    }


    public function inquire(): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'inquire',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    public function pend(): Fulfillment {
        var request = ConnectApi.getInstance().fulfillment.changeRequestStatus(
            this.id,
            'pend',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    public function assignTo(assignee_id: String): Fulfillment {
       var request = ConnectApi.getInstance().fulfillment.assignRequest(
            this.id,
            assignee_id
        );
        return Model.parse(Fulfillment, request);
    }
}
