package connect.models;


/**
    Represents a user within the platform.
**/
class User extends IdModel {
    /** User name. **/
    public var name(default, null): String;


    /** User email. **/
    public var email(default, null): String;
}
