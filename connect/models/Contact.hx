package connect.models;


/**
    Person of contact.
**/
class Contact extends Model {
    /** First name. **/
    public var firstName: String;


    /** Last name. **/
    public var lastName: String;


    /** Email address. **/
    public var email: String;


    /** Phone number. **/
    public var phoneNumber: PhoneNumber;
}
