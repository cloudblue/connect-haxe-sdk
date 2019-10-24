package connect.models;


/**
    Tier Accounts.
**/
class TierAccount extends IdModel {
    /** Tier name. **/
    public var name: String;


    /** Tier ContactInfo object. **/
    public var contactInfo: ContactInfo;


    /** Only in case of filtering by this field. **/
    public var externalId: String;


    /** Only in case of filtering by this field. **/
    public var externalUid: String;
}
