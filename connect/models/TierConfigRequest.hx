/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;


/** This class represents a request on a `TierConfig` **/
class TierConfigRequest extends IdModel {
    /** TCR type. One of: setup, update. **/
    public var type: String;


    /** TCR current status. One of: tiers_setup, pending, inquiring, approved, failed. **/
    public var status: String;


    /** Full representation of TierConfig Object. **/
    public var configuration: TierConfig;


    /** Full representation of parent TierConfig. **/
    public var parentConfiguration: TierConfig;


    /** Reference object to TierAccount. **/
    public var account: TierAccount;


    /** Reference object to product (application). **/
    public var product: Product;


    /** Tier level for product from customer perspective (1 or 2). **/
    public var tierLevel: Int;


    /**
        List of parameter data objects as in Asset Object.
        Params can be modified only in Pending state.
    **/
    public var params: Collection<Param>;


    /** TCR environment (test, prod or preview) **/
    public var environment: String;


    /** User assigned to this TCR. **/
    public var assignee: User;


    /** Template Object. This is filled only if TCR is approved. **/
    public var template: Template;


    /** Failing reason. This is filled only if TCR is failed. **/
    public var reason: String;


    /**
        Activation object. This is created only if TCR has ordering parameters
        and seen in inquiring state of the TCR.
    **/
    public var activation: Activation;


    /** TCR pending notes. Notes can be modified only in Pending state. **/
    public var notes: String;


    /** Tier Config Tequest events. **/
    public var events: Events;


    // Undocumented fields (they appear in PHP SDK)


    /** TierConfig tier accounts. **/
    public var tiers: Tiers;


    /** TierConfig marketplace. **/
    public var marketplace: Marketplace;


    /** TierConfig contract. **/
    public var contract: Contract;


    /**
        Lists all TierConfigRequests that match the given filters. Supported filters are:

        - type (=, in)
        - status (=, in)
        - id (=, in)
        - configuration__id (=, in)
        - configuration__tier_level (=, in)
        - configuration__account__id (=, in)
        - configuration__product__id (=, in)
        - assignee__id (=)
        - unassigned (bool)
        - configuration__account__external_uid (=)

        @returns A Collection of TierConfigRequests.
    **/
    public static function list(filters: Query) : Collection<TierConfigRequest> {
        final requests = Env.getTierApi().listTierConfigRequests(filters);
        return Model.parseArray(TierConfigRequest, requests);
    }


    /** @returns The TierConfigRequest with the given id, or `null` if it was not found. **/
    public static function get(id: String): TierConfigRequest {
        try {
            final request = Env.getTierApi().getTierConfigRequest(id);
            return Model.parse(TierConfigRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Registers a new TierConfigRequest on Connect, based on the data of `this`
        TierConfigRequest, which should have a value at least in the following fields:

        - configuration.product.id
        - configuration.connection.id (not required on preview)
        - configuration.marketplace.id (only available for preview)
        - configuration.account.id
        - configuration.parentAccount.id (optional)
        - configuration.parentAccount.externalUid (optional)
        - configuration.tierLevel
        - configuration.params (id and value of given params)

        @returns The new TierConfigRequest, or `null` if it couldn't be created.
    **/
    public function register(): TierConfigRequest {
        try {
            final request = Env.getTierApi().createTierConfigRequest(this.toString());
            return Model.parse(TierConfigRequest, request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Updates the TierConfigRequest in the server with the data changed in `this` model.

        @returns The TierConfigRequest returned from the server, which should contain
        the same data as `this` TierConfigRequest.
    **/
    public function update(): TierConfigRequest {
        final request = Env.getTierApi().updateTierConfigRequest(
            this.id,
            this.toString());
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Changes `this` TierConfigRequest status to "approved", sending the id of a Template
        to render on the portal.

        When processing requests within a `Flow`, you should use the `Flow.approveByTemplate`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated status.
    **/
    public function approveByTemplate(id: String): TierConfigRequest {
        final request = Env.getTierApi().approveTierConfigRequest(
            this.id,
            haxe.Json.stringify({template_id: id})
        );
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Changes `this` TierConfigRequest status to "approved", rendering a tile on the portal with
        the given Markdown `text`.

        When processing requests within a `Flow`, you should use the `Flow.approveByTile`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated status.
    **/
    public function approveByTile(text: String): TierConfigRequest {
        final request = Env.getTierApi().approveTierConfigRequest(
            this.id,
            haxe.Json.stringify({activation_tile: text})
        );
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Changes the status of `this` TierConfigRequest to "failed".

        When processing requests within a `Flow`, you should use the `Flow.fail`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): TierConfigRequest {
        final request = Env.getTierApi().failTierConfigRequest(
            this.id,
            haxe.Json.stringify({reason: reason})
        );
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Changes the status of `this` TierConfigRequest to "inquiring".

        When processing requests within a `Flow`, you should use the `Flow.inquire`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated status.
    **/
    public function inquire(): TierConfigRequest {
        final request = Env.getTierApi().inquireTierConfigRequest(this.id);
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Changes the status of `this` TierConfigRequest to "pending".

        When processing requests within a `Flow`, you should use the `Flow.pend`
        method instead of this one, since it finishes the flow and logs the information.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated status.
    **/
    public function pend(): TierConfigRequest {
        final request = Env.getTierApi().pendTierConfigRequest(this.id);
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Assigns this TierConfigRequest.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated assignee.
    **/
    public function assign(): TierConfigRequest {
        final request = Env.getTierApi().assignTierConfigRequest(this.id);
        return Model.parse(TierConfigRequest, request);
    }


    /**
        Unassigns this TierConfigRequest.

        @returns The TierConfigRequest returned from the server, which should contain
        the updated assignee.
    **/
    public function unassign(): TierConfigRequest {
        final request = Env.getTierApi().unassignTierConfigRequest(this.id);
        return Model.parse(TierConfigRequest, request);
    }


    /** @returns The `Param` with the given id, or `null` if it was not found. **/
    public function getParamById(paramId: String): Param {
        final params = this.params.toArray().filter(function(param) {
            return param.id == paramId;
        });
        return (params.length > 0) ? params[0] : null;
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'configuration' => 'TierConfig',
            'parentConfiguration' => 'TierConfig',
            'account' => 'TierAccount',
            'assignee' => 'User'
        ]);
    }
}
