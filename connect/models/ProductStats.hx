package connect.models;


/**
    Statistics of product use.
**/
class ProductStats extends Model {
    /** Number of listings (direct use of product by provider). **/
    public var listing(default, null): Int;


    /** Agreements related to the product. **/
    public var agreements(default, null): ProductStatsInfo;


    /** Contracts related to the product. **/
    public var contracts(default, null): ProductStatsInfo;


    public function new() {
        super();
        this._setFieldClassNames([
            'agreements' => 'ProductStatsInfo',
            'contracts' => 'ProductStatsInfo'
        ]);
    }
}
