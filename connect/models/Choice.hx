package connect.models;


/**
    A value choice for a parameter.
**/
class Choice extends Model {
    /** The value of `this` Choice. **/
    public var value(default, null): String;

    /** The label shown to the user in the dropdown selector. **/
    public var label(default, null): String;
}
