package connect.models;


/**
    Item renewal data.
**/
class Renewal extends Model {
    /** Date of renewal beginning. **/
    public var from: String;


    /** Date of renewal end. **/
    public var to: String;


    /** Size of renewal period. **/
    public var periodDelta: Int;


    /** Unit of measure for renewal period. One of: year, month, day, hour. **/
    public var periodUom: String;
}
