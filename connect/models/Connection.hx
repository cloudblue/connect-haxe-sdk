package connect.models;


/**
    Represents a communication channel which provides the ability
    to order products within particular hub.

    Standalone connection is required for each product and for each provider account.
**/
class Connection extends IdModel {
    /** Type of connection (one of: production, test, preview). **/
    public var type(default, null): String;


    /** Provider account reference. **/
    public var provider(default, null): Account;


    /** Vendor account reference. **/
    public var vendor(default, null): Account;


    /** Product reference. **/
    public var product(default, null): Product;


    /** Hub reference. **/
    public var hub(default, null): Hub;


    public function new() {
        super();
        this._setFieldClassNames([
            'provider' => 'Account',
            'vendor' => 'Account'
        ]);
    }
}
