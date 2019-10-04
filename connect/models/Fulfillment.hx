package connect.models;

import connect.api.QueryParams;


class Fulfillment extends IdModel {
    public var type(default, null): String;
    public var created(default, null): String;
    public var updated(default, null): String;
    public var status(default, null): String;
    public var paramsFormUrl(default, null): String;
    public var activationKey(default, null): String;
    public var reason(default, null): String;
    public var note(default, default): String;
    public var asset(default, null): Asset;
    public var contract(default, null): Contract;
    public var marketplace(default, null): Marketplace;
    //public var assignee(default, null): User;


    public static function list(?filters: QueryParams) : Collection<Fulfillment> {
        var requests = Environment.getFulfillmentApi().listRequests(filters);
        return Model.parseArray(Fulfillment, requests);
    }


    public static function get(id: String): Fulfillment {
        try {
            var request = Environment.getFulfillmentApi().getRequest(id);
            return Model.parse(Fulfillment, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    public static function create(): Fulfillment {
        var request = Environment.getFulfillmentApi().createRequest();
        return Model.parse(Fulfillment, request);
    }


    public function update(): Fulfillment {
        var request = Environment.getFulfillmentApi().updateRequest(
            this.id,
            this.toString());
        return Model.parse(Fulfillment, request);
    }


    public function approveByTemplate(id: String): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({template_id: id})
        );
        return Model.parse(Fulfillment, request);
    }


    public function approveByTile(text: String): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({activation_tile: text})
        );
        return Model.parse(Fulfillment, request);
    }


    public function fail(reason: String): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'fail',
            haxe.Json.stringify({reason: reason})
        );
        return Model.parse(Fulfillment, request);
    }


    public function inquire(): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'inquire',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    public function pend(): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'pend',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    public function assignTo(assignee_id: String): Fulfillment {
       var request = Environment.getFulfillmentApi().assignRequest(
            this.id,
            assignee_id
        );
        return Model.parse(Fulfillment, request);
    }


    public function needsMigration(key: String = 'migration_info'): Bool {
        var param = this.asset.getParamById(key);
        return param != null && param.value != null && param.value != '';
    }


    public function getConversation(): Conversation {
        var convs = Conversation.list(new QueryParams().set('instance_id', this.id));
        var conv = (convs.length() > 0) ? convs.get(0) : null;
        if  (conv != null && conv.id != null && conv.id != '') {
            return Conversation.get(conv.id);
        } else {
            return null;
        }
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'assignee' => 'User'
        ]);
    }
}
