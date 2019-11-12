package connect.models;


/**
    Statistics of product use.
**/
class ProductStats extends Model {
    /** Number of listings (direct use of product by provider). **/
    public var listings: Int;


    /** Agreements related to the product. **/
    public var agreements: ProductStatsInfo;


    /** Contracts related to the product. **/
    public var contracts: ProductStatsInfo;


    public function new() {
        super();
        this._setFieldClassNames([
            'agreements' => 'ProductStatsInfo',
            'contracts' => 'ProductStatsInfo'
        ]);
    }
}
