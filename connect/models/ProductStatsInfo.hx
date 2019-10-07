package connect.models;


/**
    Information of some `ProductStats` fields.
**/
class ProductStatsInfo extends Model {
    /** Number of distributions related to the product. **/
    public var distribution(default, null): Int;


    /** Number of sourcings related to the product. **/
    public var sourcing(default, null): Int;
}
