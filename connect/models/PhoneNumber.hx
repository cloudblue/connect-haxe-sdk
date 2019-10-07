package connect.models;


/**
    Phone number.
**/
class PhoneNumber extends Model {
    /** Country code. **/
    public var countryCode(default, null): String;


    /** Area code. **/
    public var areaCode(default, null): String;


    /** Phone number. **/
    public var phoneNumber(default, null): String;


    /** Phone extension. **/
    public var extension(default, null): String;
}
