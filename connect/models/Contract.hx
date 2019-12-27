/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    A contract in the Connect platform.
**/
class Contract extends IdModel {
    /** Contract name. **/
    public var name: String;


    /** Version of the contract (same as associated agreement version). **/
    public var version: Int;


    /** Type of contract (same as agreement type). One of: distribution, program, service. **/
    public var type: String;


    /** Contract status. One of: enrolling, pending, active, terminated, rejected. **/
    public var status: String;


    /** Agreement object reference. **/
    public var agreement: Agreement;


    /** Marketplace object reference. **/
    public var marketplace: Marketplace;


    /** Owner Account object reference. **/
    public var owner: Account;


    /** Create User object reference. **/
    public var creator: User;


    /** Contract creation date. **/
    public var created: DateTime;


    /** Contract status update date. **/
    public var updated: DateTime;


    /** Contract enrollment date. **/
    public var enrolled: DateTime;


    /** Contract version creation date. **/
    public var versionCreated: DateTime;


    /** Activation informacion. **/
    public var activation: Activation;


    /** Signee User object reference, who signed the contract. **/
    public var signee: User;


    public function new() {
        super();
        this._setFieldClassNames([
            'created' => 'DateTime',
            'updated' => 'DateTime',
            'enrolled' => 'DateTime',
            'versionCreated' => 'DateTime',
            'owner' => 'Account',
            'creator' => 'User',
            'signee' => 'User',
        ]);
    }
}
