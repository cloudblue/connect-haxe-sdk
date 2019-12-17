package connect.models;


/**
    Represents a communication channel which provides the ability
    to order products within particular hub.

    Standalone connection is required for each product and for each provider account.
**/
class Connection extends IdModel {
    /** Type of connection (one of: production, test, preview). **/
    public var type: String;


    /** Provider account reference. **/
    public var provider: Account;


    /** Vendor account reference. **/
    public var vendor: Account;


    /** Product reference. **/
    public var product: Product;


    /** Hub reference. **/
    public var hub: Hub;


    // Undocumented fields (they appear in PHP SDK)


    public var status: String;


    public var createdAt: String;


    public function new() {
        super();
        this._setFieldClassNames([
            'provider' => 'Account',
            'vendor' => 'Account'
        ]);
    }
}
