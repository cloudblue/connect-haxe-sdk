package connect.models;


class Contact extends Model {
    public var firstName(default, null): String;
    public var lastName(default, null): String;
    public var email(default, null): String;
    public var phoneNumber(default, null): PhoneNumber;
}
