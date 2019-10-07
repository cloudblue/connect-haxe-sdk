package connect.models;


/**
    A Hub.
**/
class Hub extends IdModel {
    /** Hub name. **/
    public var name(default, null): String;


    /** Reference to the company Account the hub belongs to. **/
    public var company(default, null): Account;


    /** Hub description (Markdown text). **/
    public var description(default, null): String;


    /** Hub instance. **/
    public var instance(default, null): Instance;


    /** Events occurred on Hub. **/
    public var events(default, null): Events;


    /** Hub stats. **/
    public var stats(default, null): HubStats;


    public function new() {
        super();
        this._setFieldClassNames([
            'company' => 'Account',
            'stats' => 'HubStats'
        ]);
    }
}
