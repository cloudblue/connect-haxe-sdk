package connect.models;


class User extends IdModel {
    public var name(default, null): String;
    public var email(default, null): String;
}