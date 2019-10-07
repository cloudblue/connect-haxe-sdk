package connect.models;


/**
    Represents the information of a contact.
**/
class ContactInfo extends Model {
    /** Street address, first line. **/
    public var addressLine1(default, null): String;


    /** Street address, second line. **/
    public var addressLine2(default, null): String;


    /** Country code. **/
    public var country(default, null): String;


    /** State name. **/
    public var state(default, null): String;


    /** City name. **/
    public var city(default, null): String;


    /** Postal ZIP code. **/
    public var postalCode(default, null): String;


    /** Person of contact. **/
    public var contact(default, null): Contact;
}
