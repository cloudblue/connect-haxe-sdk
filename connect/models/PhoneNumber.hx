package connect.models;


class PhoneNumber extends Model {
    public var countryCode(default, null): String;
    public var areaCode(default, null): String;
    public var phoneNumber(default, null): String;
    public var extension(default, null): String;
}
