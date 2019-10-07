package connect.models;


/**
    Tier Accounts.
**/
class TierAccount extends IdModel {
    /** Tier name. **/
    public var name(default, null): String;


    /** Tier ContactInfo object. **/
    public var contactInfo(default, null): ContactInfo;


    /** Only in case of filtering by this field. **/
    public var externalId(default, null): String;


    /** Only in case of filtering by this field. **/
    public var externalUid(default, null): String;
}
