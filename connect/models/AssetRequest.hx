/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;
import connect.util.DateTime;

/**
    Represents a request of the Fulfillment Api.
**/
class AssetRequest extends IdModel {
    /** Type of request. One of: purchase, change, suspend, resume, renew, cancel. **/
    public var type: String;

    /** Date of request creation. **/
    public var created: DateTime;

    /** Date of last request modification. **/
    public var updated: DateTime;

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

    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'updated' => 'DateTime',
            'assignee' => 'String' // Assigne could be an object, so force conversion to string
        ]);
    }

    /**
        Lists all requests that match the given filters. Supported filters are:

        - `status`
        - `created`
        - `id` (List support)
        - `type` (purchase|renew|change|cancel)
        - `asset.id` (asset_id) - (List support)
        - `asset.product.id` (product_id)
        - `asset.product.name` - (List support)
        - `asset.hub.id`
        - `asset.connection.hub.name` - (List support)
        - `asset.connection.provider.id`
        - `asset.connection.provider.name` - (List support)
        - `asset.connection.vendor.name` - (List support)
        - `asset.tiers.customer.id` (Customer ID)
        - `asset.tiers.tier1.id`
        - `asset.tiers.tier2.id`
        - `asset.connection.type` (test|production|preview)

        @returns A Collection of AssetRequests.
    **/
    public static function list(filters: Query) : Collection<AssetRequest> {
        final requests = Env.getFulfillmentApi().listRequests(filters);
        return Model.parseArray(AssetRequest, requests);
    }

    /** @returns The AssetRequest with the given id, or `null` if it was not found. **/
    public static function get(id: String): AssetRequest {
        try {
            final request = Env.getFulfillmentApi().getRequest(id);
            return Model.parse(AssetRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Registers a new AssetRequest on Connect, based on the data of `this` AssetRequest, which
        should have a value at least in the following fields:

        - type
        - asset.externalUid
        - asset.items
        - asset.product.id
        - asset.tiers
        - marketplace.id

        @returns The new AssetRequest, or `null` if it couldn't be created.
    **/
    public function register(): AssetRequest {
        try {
            final request = Env.getFulfillmentApi().createRequest(this.toString());
            return Model.parse(AssetRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Updates the request in the server with the data changed in `this` model.

        If no parameters are specified for updating, you should reassign your request with the
        object returned by this method, so the next time you call `update` on the object, the SDK
        knows the fields that already got updated in a previous call, like this:

        ```
        request = request.update(null);
        ```

        @param params A collection of parameters to update. If `null` is passed, then the
        parameters that have changed in the request will be sent.
        @returns The AssetRequest returned from the server, which should contain
        the same data as `this` AssetRequest, or `null` if the updating fails.
    **/
    public function update(params: Collection<Param>): AssetRequest {
        try {
            if (params == null) {
                final diff = this._toDiff();
                final hasModifiedFields = Reflect.fields(diff).length > 1;
                if (hasModifiedFields) {
                    final request = Env.getFulfillmentApi().updateRequest(
                        this.id,
                        haxe.Json.stringify(addValueToParams(diff)));
                    return Model.parse(AssetRequest, request);
                } else {
                    return this;
                }
            } else {
                if (params.length() > 0) {
                    Env.getFulfillmentApi().updateRequest(
                        this.id,
                        '{"asset":{"params":${params.toString()}}}');
                }
                return this;
            }
        } catch (ex: Dynamic) {
            return null;
        }
    }

    private function addValueToParams(obj: Dynamic): Dynamic {
        final asset = Reflect.field(obj, 'asset');
        final params: Array<Dynamic> = (asset != null) ? Reflect.field(asset, 'params') : null;
        if (params != null) {
            Lambda.iter(params, function(p) {
                if (!Reflect.hasField(p, 'value')) {
                    final value = this.asset.getParamById(Reflect.field(p, 'id')).value;
                    Reflect.setField(p, 'value', value);
                }
            });
        }
        return obj;
    }

    /**
        Changes `this` AssetRequest status to "approved", sending the id of a Template to render
        on the portal.

        When processing requests within a `Flow`, you should use the `Flow.approveByTemplate`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The AssetRequest returned from the server, which should contain
        the updated status.
    **/
    public function approveByTemplate(id: String): AssetRequest {
        final request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({template_id: id})
        );
        this._updateConversation('Request approved using template $id.');
        return Model.parse(AssetRequest, request);
    }

    /**
        Changes `this` AssetRequest status to "approved", rendering a tile on the portal with
        the given Markdown `text`.

        When processing requests within a `Flow`, you should use the `Flow.approveByTile`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The AssetRequest returned from the server, which should contain
        the updated status.
    **/
    public function approveByTile(text: String): AssetRequest {
        final request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'approve',
            haxe.Json.stringify({activation_tile: text})
        );
        this._updateConversation('Request approved using custom activation tile.');
        return Model.parse(AssetRequest, request);
    }

    /**
        Changes the status of `this` AssetRequest to "failed".

        When processing requests within a `Flow`, you should use the `Flow.fail`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The AssetRequest returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): AssetRequest {
        final request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'fail',
            haxe.Json.stringify({reason: reason})
        );
        this._updateConversation('Request failed: $reason.');
        return Model.parse(AssetRequest, request);
    }

    /**
        Changes the status of `this` AssetRequest to "inquiring".

        When processing requests within a `Flow`, you should use the `Flow.inquire`
        method instead of this one, since it finishes the flow and logs the information.

        @param templateId Id of the template to use in the portal, or `null` to not use any.
        @returns The AssetRequest returned from the server, which should contain
        the updated status.
    **/
    public function inquire(templateId: String): AssetRequest {
        final body = (templateId != null)
            ? {template_id: templateId}
            : {};
        final request = Env.getFulfillmentApi().changeRequestStatus(
            this.id,
            'inquire',
            haxe.Json.stringify(body)
        );
        this._updateConversation('Request inquired.');
        return Model.parse(AssetRequest, request);
    }

    /**
        Changes the status of `this` AssetRequest to "pending".

        When processing requests within a `Flow`, you should use the `Flow.pend`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The AssetRequest returned from the server, which should contain
        the updated status.
    **/
    public function pend(): AssetRequest {
        final request = Env.getFulfillmentApi().changeRequestStatus(this.id, 'pend', '{}');
        this._updateConversation('Request pended.');
        return Model.parse(AssetRequest, request);
    }

    /**
        Assigns `this` request to the assignee with the given `assigneeId`.

        @returns The AssetRequest returned from the server, which should contain
        the updated assignee.
    **/
    public function assign(assigneeId: String): AssetRequest {
        final request = Env.getFulfillmentApi().assignRequest(this.id, assigneeId);
        this._updateConversation('Request assigned to $assigneeId.');
        return Model.parse(AssetRequest, request);
    }

    /**
        @returns Whether `this` AssetRequest is pending migration. This is indicated by the
        presence of a parameter (by default name "migration_info") that contains JSON data.
    **/
    public function needsMigration(key: String = 'migration_info'): Bool {
        final param = this.asset.getParamById(key);
        return param != null && param.value != null && param.value != '';
    }

    /** @returns The Conversation assigned to `this` AssetRequest, or `null` if there is none. **/
    public function getConversation(): Conversation {
        final convs = Conversation.list(new Query().equal('instance_id', this.id));
        final conv = (convs.length() > 0) ? convs.get(0) : null;
        if  (conv != null && conv.id != null && conv.id != '') {
            return Conversation.get(conv.id);
        } else {
            return null;
        }
    }

    @:dox(hide)
    public function _updateConversation(message: String): Void {
        final conversation = this.getConversation();
        if (conversation != null) {
            try {
                conversation.createMessage(message);
            } catch (ex: Dynamic) {
                Env.getLogger().write(
                    connect.logger.Logger.LEVEL_ERROR,
                    'Error updating conversation for request ${this.id}: $message');
            }
        }
    }
}
