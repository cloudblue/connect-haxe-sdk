/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.util.Collection;
import connect.util.DateTime;


class Agreement extends IdModel {
    /** Type of the agreement. One of: distribution, program, service. **/
    public var type: String;

    /** Title of the agreement. **/
    public var title: String;

    /** Agreement details (Markdown). **/
    public var description: String;

    /** Date of creation of the agreement. **/
    public var created: DateTime;

    /**
        Date of the update of the agreement. It can be creation
        of the new version, change of the field, etc. (any change).
    **/
    public var updated: DateTime;

    /** Reference to the owner account object. **/
    public var owner: Account;

    /** Agreement stats. **/
    public var stats: AgreementStats;

    /** Reference to the user who created the version. **/
    public var author: User;

    /** Chronological number of the version. **/
    public var version: Int;

    /** State of the version. **/
    public var active: Bool;

    /** Url to the document. **/
    public var link: String;

    /** Date of the creation of the version. **/
    public var versionCreated: DateTime;

    /** Number of contracts this version has. **/
    public var versionContracts: Int;

    /** Program agreements can have distribution agreements associated with them. **/
    public var agreements: Collection<Agreement>;

    /** Reference to the parent program agreement (for distribution agreement). **/
    public var parent: Agreement;

    /** Reference to marketplace object (for distribution agreement). **/
    public var marketplace: Marketplace;

    // Undocumented fields (they appear in PHP SDK)

    /** Name of Agreement. **/
    public var name: String;

    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'updated' => 'DateTime',
            'owner' => 'Account',
            'stats' => 'AgreementStats',
            'author' => 'User',
            'versionCreated' => 'DateTime',
            'parent' => 'Agreement'
        ]);
    }

    /**
        Lists all agreements that match the given filters. Supported filters are:

        - `type`
        - `owner__id`

        @returns A Collection of Agreements.
    **/
    public static function list(filters: Query): Collection<Agreement> {
        final agreements = Env.getMarketplaceApi().listAgreements(filters);
        return Model.parseArray(Agreement, agreements);
    }

    /** @returns The Agreement with the given id, or `null` if it was not found. **/
    public static function get(id: String): Agreement {
        try {
            final agreement = Env.getMarketplaceApi().getAgreement(id);
            return Model.parse(Agreement, agreement);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
     * Registers a new Agreement on Connect, based on the data of `this` Agreement.
     * @return The new Agreement, or `null` if it couldn't be created
     */
    public function register(): Agreement {
        try {
            final agreement = Env.getMarketplaceApi().createAgreement(this.toString());
            return Model.parse(Agreement, agreement);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Updates the agreement in Connect platform with the data changed in `this` model.

        You should reassign your agreement with the object returned by this method, so the next time
        you call `update` on the object, the SDK knows the fields that already got updated in a
        previous call, like this:

        ```
        agreement = agreement.update();
        ```

        @returns The Agreement returned from the server, which should contain
        the same data as `this` Agreement.
    **/
    public function update(): Agreement {
        final diff = this._toDiff();
        final hasModifiedFields = Reflect.fields(diff).length > 1;
        if (hasModifiedFields) {
            final agreement = Env.getMarketplaceApi().updateAgreement(
                this.id,
                haxe.Json.stringify(diff));
            return Model.parse(Agreement, agreement);
        } else {
            return this;
        }
    }

    /**
     * Removes `this` Agreement from Connect.
     * @return Bool If agreement could be removed, returns `true`. Otherwise, returns `false`.
     */
    public function remove(): Bool {
        try {
            Env.getMarketplaceApi().removeAgreement(this.id);
            return true;
        } catch (ex: Dynamic) {
            return false;
        }
    }

    /*
    /**
        Lists all versions for `this` Agreement.

        @returns A Collection of Agreements.
    **/
    public function listVersions(): Collection<Agreement> {
        final versions = Env.getMarketplaceApi().listAgreementVersions(this.id);
        return Model.parseArray(Agreement, versions);
    }

    /**
     * Registers a new version on Connect, based on the data of `this` Agreement.
     * @return The new version, or `null` if it couldn't be registered
     */
    public function registerVersion(): Agreement {
        try {
            final version = Env.getMarketplaceApi().newAgreementVersion(this.id, this.toString());
            return Model.parse(Agreement, version);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
     * @return Agreement Returns the specified version for `this` Agreement, or `null` if it was not found.
     */
    public function getVersion(version: Int): Agreement {
        try {
            final version = Env.getMarketplaceApi().getAgreementVersion(this.id, Std.string(version));
            return Model.parse(Agreement, version);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
     * Removes the specified version from `this` agreement on Connect.
     * @param version The version to remove.
     */
    public function removeVersion(version: Int): Bool {
        try {
            Env.getMarketplaceApi().removeAgreementVersion(this.id, Std.string(version));
            return true;
        } catch (ex: Dynamic) {
            return false;
        }
    }

    /**
     * Lists all sub agreements linked to `this` Agreement.
     * @return Collection<Agreement>
     */
    public function listSubAgreements(): Collection<Agreement> {
        final agreements = Env.getMarketplaceApi().listAgreementSubAgreements(this.id);
        return Model.parseArray(Agreement, agreements);
    }

    /**
     * Registers a new Agreement on Connect and links it to `this` Agreement.
     * @return The new Agreement, or `null` if it couldn't be created
     */
    public function registerSubAgreement(agreement: Agreement): Agreement {
        try {
            final agreement = Env.getMarketplaceApi().createAgreementSubAgreement(this.id, agreement.toString());
            return Model.parse(Agreement, agreement);
        } catch (ex: Dynamic) {
            return null;
        }
    }
}
