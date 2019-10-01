package connect.models;


class Account extends IdModel {
    public var name(default, null): String;
    public var type(default, null): String;
    public var events(default, null): Events;
    public var brand(default, null): String;
    public var externalId(default, null): String;
    public var sourcing(default, null): Bool;
}
