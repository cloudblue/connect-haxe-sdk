package connect.models;

import connect.api.QueryParams;


/**
    Represents a request of the Fulfillment Api.
**/
class Request extends IdModel {
    /** Type of request. One of: purchase, change, suspend, resume, renew, cancel. **/
    public var type: String;


    /** Date of request creation. **/
    public var created: String;


    /** Date of last request modification. **/
    public var updated: String;


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
    public var status: String;


    /** URL for customer/reseller/provider for modifying param based on vendor's feedback. **/
    public var paramsFormUrl: String;


    /**
        Activation key content for activating the subscription on vendor portal.
        This markdown formatted message is sent to customer.
    **/
    public var activationKey: String;


    /** Fail reason in case of status of request is failed. **/
    public var reason: String;


    /** Details of note. **/
    public var note: String;


    /** Asset object **/
    public var asset: Asset;


    /** Contract object. **/
    public var contract: Contract;


    /** Marketplace object. **/
    public var marketplace: Marketplace;


    /**
        Connect returns either a String or a JSON object in this field. When it is an object,
        its String representation is stored.
    **/
    public var assignee: String;


    /**
        Lists all Requests that match the given filters. Supported filters are:

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

        @returns A Collection of Requests.
    **/
    public static function list(filters: QueryParams) : Collection<Request> {
        var requests = Env.getFulfillmentApi().listRequests(filters);
        return Model.parseArray(Request, requests);
    }


    /** @returns The Request with the given id, or `null` if it was not found. **/
    public static function get(id: String): Request {
        try {
            var request = Env.getFulfillmentApi().getRequest(id);
            return Model.parse(Request, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Creates a new Request registered on Connect, based on the data of `this` Request, which
        should have a value at least in the following fields:

        - type
        - asset.externalUid
        - asset.items
        - asset.product.id
        - asset.tiers
        - marketplace.id

        @returns The created Request, or `null` if it couldn't be created.
    **/
    public function create(): Request {
        try {
            final request = Env.getFulfillmentApi().createRequest(this.toString());
            return Model.parse(Request, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Updates the Request in the server with the data changed in `this` model.

        @returns The Request returned from the server, which should contain
        the same data as `this` Request.
    **/
    public function update(): Request {
        var request = Env.getFulfillmentApi().updateRequest(
            this.id,
            this.toString());
        return Model.parse(Request, request);
    }


    /**
        Changes `this` Request status to "approved", sending the id
        of a Template to render on the portal.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function approveByTemplate(id: String): Request {
        var request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({template_id: id})
        );
        this._updateConversation('Request approved using template $id.');
        return Model.parse(Request, request);
    }


    /**
        Changes `this` Request status to "approved", rendering a tile on the portal with
        the given Markdown `text`.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function approveByTile(text: String): Request {
        var request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({activation_tile: text})
        );
        this._updateConversation('Request approved using custom activation tile.');
        return Model.parse(Request, request);
    }


    /**
        Changes the status of `this` Request to "failed".

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): Request {
        var request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'fail',
            haxe.Json.stringify({reason: reason})
        );
        this._updateConversation('Request failed: $reason.');
        return Model.parse(Request, request);
    }


    /**
        Changes the status of `this` Request to "inquiring".

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function inquire(): Request {
        var request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'inquire',
            haxe.Json.stringify({})
        );
        this._updateConversation('Request inquired.');
        return Model.parse(Request, request);
    }


    /**
        Changes the status of `this` Request to "pending".

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function pend(): Request {
        var request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'pend',
            haxe.Json.stringify({})
        );
        this._updateConversation('Request pended.');
        return Model.parse(Request, request);
    }


    /**
        Assigns this request to the assignee with the given `assigneeId`.

        @returns The Request returned from the server, which should contain
        the updated assignee.
    **/
    public function assign(assigneeId: String): Request {
       var request = Env.getFulfillmentApi().assignRequest(
            this.id,
            assigneeId
        );
        this._updateConversation('Request assigned to $assigneeId.');
        return Model.parse(Request, request);
    }


    
    /**
        @returns Whether `this` Request is pending migration. This is indicated by the
        presence of a parameter (by default name "migration_info") that contains JSON data.
    **/
    public function needsMigration(key: String = 'migration_info'): Bool {
        var param = this.asset.getParamById(key);
        return param != null && param.value != null && param.value != '';
    }


    /** @returns The Conversation assigned to `this` Request, or `null` if there is none. **/
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
            // Assigne could be an object, so force conversion to string
            'assignee' => 'String'
        ]);
    }


    @:dox(hide)
    public function _updateConversation(message: String): Void {
        final conversation = this.getConversation();
        if (conversation != null) {
            try {
                conversation.createMessage(message);
            } catch (ex: Dynamic) {
                Env.getLogger().error('Error updating conversation for request ${this.id}: $message');
            }
        }
    }
}
