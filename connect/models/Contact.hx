package connect.models;


/**
    Person of contact.
**/
class Contact extends Model {
    /** First name. **/
    public var firstName(default, null): String;


    /** Last name. **/
    public var lastName(default, null): String;


    /** Email address. **/
    public var email(default, null): String;


    /** Phone number. **/
    public var phoneNumber(default, null): PhoneNumber;
}
