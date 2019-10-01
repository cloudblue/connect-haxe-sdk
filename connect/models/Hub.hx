package connect.models;


class Hub extends IdModel {
    public var name(default, null): String;
    public var company(default, null): Account;
    public var description(default, null): String;
    public var instance(default, null): Instance;
    public var events(default, null): Events;
    public var stats(default, null): HubStats;


    public function new() {
        this._setFieldClassNames([
            'company' => 'Account',
            'stats' => 'HubStats'
        ]);
    }
}
