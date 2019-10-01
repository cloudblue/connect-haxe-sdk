package connect.models;


class Marketplace extends IdModel {
    public var name(default, null): String;
    public var description(default, null): String;
    public var activeContracts(default, null): Int;
    public var icon(default, null): String;
    public var owner(default, null): Account;
    public var hubs(default, null): Collection<ExtIdHub>;
    public var zone(default, null): String;
    public var countries(default, null): List<Country>;
    public var souncing(default, null): Bool;

    public function new() {
        this._setFieldClassNames([
            'hubs' => 'ExtIdHub',
            'countries' => 'Country'
        ]);
    }
}
