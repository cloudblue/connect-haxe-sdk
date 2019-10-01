package connect.models;


class Contract extends IdModel {
    public var name(default, null): String;
    public var version(default, null): Int;
    public var type(default, null): String;
    public var status(default, null): String;
    public var agreement(default, null): Agreement;
    public var marketplace(default, null): Marketplace;
    public var owner(default, null): Account;
    public var creator(default, null): User;
    public var created(default, null): String;
    public var updated(default, null): String;
    public var enrolled(default, null): String;
    public var versionCreated(default, null): String;
    public var activation(default, null): Activation;
    public var signee(default, null): User;

    public function new() {
        this._setFieldClassNames([
            'owner' => 'Account',
            'creator' => 'User',
            'signee' => 'User',
        ]);
    }
}
