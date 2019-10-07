package connect.models;


/**
    Represents an account in the Connect platform, of either a Vendor or a Provider.
**/
class Account extends IdModel {
    /** Name of account object. **/
    public var name(default, null): String;


    /** Type of the account object ("vendor" or "provider"). **/
    public var type(default, null): String;


    /** Contains the `created` event, with the date when the account object was created. **/
    public var events(default, null): Events;


    /** Brand id of the account object. **/
    public var brand(default, null): String;


    /** External id of the account object. **/
    public var externalId(default, null): String;


    /**
        Whether the account has the ability to create Sourcing Agreements (is HyperProvider),
        defaults to false.
    **/
    public var sourcing(default, null): Bool;
}
