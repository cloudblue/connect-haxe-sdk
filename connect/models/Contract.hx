package connect.models;


/**
    A contract in the Connect platform.
**/
class Contract extends IdModel {
    /** Contract name. **/
    public var name(default, null): String;


    /** Version of the contract (same as associated agreement version). **/
    public var version(default, null): Int;


    /** Type of contract (same as agreement type). One of: distribution, program, service. **/
    public var type(default, null): String;


    /** Contract status. One of: enrolling, pending, active, terminated, rejected. **/
    public var status(default, null): String;


    /** Agreement object reference. **/
    public var agreement(default, null): Agreement;


    /** Marketplace object reference. **/
    public var marketplace(default, null): Marketplace;


    /** Owner Account object reference. **/
    public var owner(default, null): Account;


    /** Create User object reference. **/
    public var creator(default, null): User;


    /** Contract creation date. **/
    public var created(default, null): String;


    /** Contract status update date. **/
    public var updated(default, null): String;


    /** Contract enrollment date. **/
    public var enrolled(default, null): String;


    /** Contract version creation date. **/
    public var versionCreated(default, null): String;


    /** Activation informacion. **/
    public var activation(default, null): Activation;


    /** Signee User object reference, who signed the contract. **/
    public var signee(default, null): User;


    public function new() {
        super();
        this._setFieldClassNames([
            'owner' => 'Account',
            'creator' => 'User',
            'signee' => 'User',
        ]);
    }
}
