/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


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
}
