package connect.models;


class Product extends IdModel {
    public var name(default, null): String;
    public var icon(default, null): String;
    public var shortDescription(default, null): String;
    public var detailedDescription(default, null): String;
    public var version(default, null): String;
    public var publishedAt(default, null): String;
    public var configurations(default, null): Configurations;
    public var customerUiSettings(default, null): CustomerUiSettings;
    public var category(default, null): Category;
    public var owner(default, null): Account;
    public var latest(default, null): Bool;
    public var stats(default, null): ProductStats;

    public function new() {
        this._setFieldClassNames([
            'owner' => 'Account',
            'stats' => 'ProductStats'
        ]);
    }
}
