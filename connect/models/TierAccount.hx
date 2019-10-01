package connect.models;


class TierAccount extends IdModel {
    public var name(default, null): String;
    public var contactInfo(default, null): ContactInfo;
    public var externalId(default, null): String;
    public var externalUid(default, null): String;
}
