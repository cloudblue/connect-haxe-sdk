package connect.models;


/**
    Phone number.
**/
class PhoneNumber extends Model {
    /** Country code. **/
    public var countryCode: String;


    /** Area code. **/
    public var areaCode: String;


    /** Phone number. **/
    public var phoneNumber: String;


    /** Phone extension. **/
    public var extension: String;
}
