package connect.models;


/**
    Item renewal data.
**/
class Renewal extends Model {
    /** Date of renewal beginning. **/
    public var from(default, null): String;


    /** Date of renewal end. **/
    public var to(default, null): String;


    /** Size of renewal period. **/
    public var periodDelta(default, null): Int;


    /** Unit of measure for renewal period. One of: year, month, day, hour. **/
    public var periodUom(default, null): String;
}
