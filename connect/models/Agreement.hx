package connect.models;


class Agreement extends IdModel {
    public var type(default, null): String;
    public var title(default, null): String;
    public var description(default, null): String;
    public var created(default, null): String;
    public var updated(default, null): String;
    public var owner(default, null): Account;
    public var stats(default, null): AgreementStats;
    public var author(default, null): User;
    public var version(default, null): Int;
    public var active(default, null): Bool;
    public var link(default, null): String;
    public var versionCreated(default, null): String;
    public var versionContracts(default, null): Int;
    public var agreements(default, null): Collection<Agreement>;
    public var parent(default, null): Agreement;
    public var marketplace(default, null): Marketplace;

    // Undocumented fields (they appear in PHP SDK)

    public var name(default, null): String;

    public function new() {
        this._setFieldClassNames([
            'owner' => 'Account',
            'stats' => 'AgreementStats',
            'author' => 'User',
            'parent' => 'Agreement'
        ]);
    }
}
