package connect.models;

import connect.api.QueryParams;


/**
    Represents a request of the Fulfillment Api.
**/
class Fulfillment extends IdModel {
    /** Type of request. One of: purchase, change, suspend, resume, renew, cancel. **/
    public var type(default, null): String;


    /** Date of request creation. **/
    public var created(default, null): String;


    /** Date of last request modification. **/
    public var updated(default, null): String;


    /**
        Status of request. One of: pending, inquiring, failed, approved.

        Valid status changes:

        - pending -> inquiring
        - pending -> failed
        - pending -> approved
        - inquiring -> failed
        - inquiring -> approved
        - inquiring -> pending
    **/
    public var status(default, null): String;


    /** URL for customer/reseller/provider for modifying param based on vendor's feedback. **/
    public var paramsFormUrl(default, null): String;


    /**
        Activation key content for activating the subscription on vendor portal.
        This markdown formatted message is sent to customer.
    **/
    public var activationKey(default, null): String;


    /** Fail reason in case of status of request is failed. **/
    public var reason(default, null): String;


    /** Details of note. **/
    public var note(default, default): String;


    /** Asset object **/
    public var asset(default, null): Asset;


    /** Contract object. **/
    public var contract(default, null): Contract;


    /** Marketplace object. **/
    public var marketplace(default, null): Marketplace;


    //public var assignee(default, null): User;


    /**
        Lists all Fulfillments that match the given filters. Supported filters are:

        - status
        - created
        - id (List support)
        - type (purchase|renew|change|cancel)
        - asset.id (asset_id) - (List support)
        - asset.product.id (product_id)
        - asset.product.name - (List support)
        - asset.hub.id
        - asset.connection.hub.name - (List support)
        - asset.connection.provider.id
        - asset.connection.provider.name - (List support)
        - asset.connection.vendor.name - (List support)
        - asset.tiers.customer.id (Customer ID)
        - asset.tiers.tier1.id
        - asset.tiers.tier2.id
        - asset.connection.type (test|production|preview)

        @returns A Collection of Fulfillments.
    **/
    public static function list(?filters: QueryParams) : Collection<Fulfillment> {
        var requests = Environment.getFulfillmentApi().listRequests(filters);
        return Model.parseArray(Fulfillment, requests);
    }


    /** @returns The Fulfillment with the given id, or `null` if it was not found. **/
    public static function get(id: String): Fulfillment {
        try {
            var request = Environment.getFulfillmentApi().getRequest(id);
            return Model.parse(Fulfillment, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Creates a new Fulfillment.

        @returns The created Fulfillment.
    **/
    public static function create(): Fulfillment {
        var request = Environment.getFulfillmentApi().createRequest();
        return Model.parse(Fulfillment, request);
    }


    /**
        Updates the Fulfillment in the server with the data changed in `this` model.

        @returns The Fulfillment returned from the server, which should contain
        the same data as `this` Fulfillment.
    **/
    public function update(): Fulfillment {
        var request = Environment.getFulfillmentApi().updateRequest(
            this.id,
            this.toString());
        return Model.parse(Fulfillment, request);
    }


    /**
        Changes `this` Fulfillment status to "approved", sending the id
        of a Template to render on the portal.

        @returns The Fulfillment returned from the server, which should contain
        the updated status.
    **/
    public function approveByTemplate(id: String): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({template_id: id})
        );
        return Model.parse(Fulfillment, request);
    }


    /**
        Changes `this` Fulfillment status to "approved", rendering a tile on the portal with
        the given Markdown `text`.

        @returns The Fulfillment returned from the server, which should contain
        the updated status.
    **/
    public function approveByTile(text: String): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({activation_tile: text})
        );
        return Model.parse(Fulfillment, request);
    }


    /**
        Changes the status of `this` Fulfillment to "failed".

        @returns The Fulfillment returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'fail',
            haxe.Json.stringify({reason: reason})
        );
        return Model.parse(Fulfillment, request);
    }


    /**
        Changes the status of `this` Fulfillment to "inquiring".

        @returns The Fulfillment returned from the server, which should contain
        the updated status.
    **/
    public function inquire(): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'inquire',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    /**
        Changes the status of `this` Fulfillment to "pending".

        @returns The Fulfillment returned from the server, which should contain
        the updated status.
    **/
    public function pend(): Fulfillment {
        var request = Environment.getFulfillmentApi().changeRequestStatus(
            this.id,
            'pend',
            haxe.Json.stringify({})
        );
        return Model.parse(Fulfillment, request);
    }


    /**
        Assigns this request to the assignee with the given `assigneeId`.

        @returns The Fulfillment returned from the server, which should contain
        the updated assignee.
    **/
    public function assignTo(assigneeId: String): Fulfillment {
       var request = Environment.getFulfillmentApi().assignRequest(
            this.id,
            assigneeId
        );
        return Model.parse(Fulfillment, request);
    }


    
    /**
        @returns Whether `this` Fulfillment is pending migration. This is indicated by the
        presence of a parameter (by default name "migration_info") that contains JSON data.
    **/
    public function needsMigration(key: String = 'migration_info'): Bool {
        var param = this.asset.getParamById(key);
        return param != null && param.value != null && param.value != '';
    }


    /** @returns The Conversation assigned to `this` Fulfillment, or `null` if there is none. **/
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
