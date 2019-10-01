package connect.models;


class Fulfillment extends IdModel {
    public var type(default, null): String;
    public var created(default, null): String;
    public var updated(default, null): String;
    public var status(default, null): String;
    public var paramsFormUrl(default, null): String;
    public var activationKey(default, null): String;
    public var reason(default, null): String;
    public var note(default, null): String;
    public var asset(default, null): Asset;
    public var contract(default, null): Contract;
    public var marketplace(default, null): Marketplace;
    //public var assignee(default, null): User;


    public function new() {
        this._setFieldClassNames([
            'assignee' => 'User'
        ]);
    }
}
