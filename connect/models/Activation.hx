package connect.models;


/**
    Contract activation information.
**/
class Activation extends Model {
    /** Activation link. **/
    public var link(default, null): String;


    /** Activation message. **/
    public var message(default, null): String;


    /** Activation date. **/
    public var date(default, null): String;
}
