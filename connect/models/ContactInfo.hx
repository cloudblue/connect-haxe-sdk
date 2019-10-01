package connect.models;


class ContactInfo extends Model {
    public var addressLine1(default, null): String;
    public var addressLine2(default, null): String;
    public var country(default, null): String;
    public var state(default, null): String;
    public var city(default, null): String;
    public var postalCode(default, null): String;
    public var contact(default, null): Contact;
}
