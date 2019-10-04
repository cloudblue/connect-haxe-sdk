package connect.models;


class Connection extends IdModel {
    public var type(default, null): String;
    public var provider(default, null): Account;
    public var vendor(default, null): Account;
    public var product(default, null): Product;
    public var hub(default, null): Hub;

    public function new() {
        super();
        this._setFieldClassNames([
            'provider' => 'Account',
            'vendor' => 'Account'
        ]);
    }
}
