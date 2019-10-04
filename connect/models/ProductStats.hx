package connect.models;


class ProductStats extends Model {
    public var listing(default, null): Int;
    public var agreements(default, null): ProductStatsInfo;
    public var contracts(default, null): ProductStatsInfo;

    public function new() {
        super();
        this._setFieldClassNames([
            'agreements' => 'ProductStatsInfo',
            'contracts' => 'ProductStatsInfo'
        ]);
    }
}