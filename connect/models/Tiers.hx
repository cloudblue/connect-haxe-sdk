package connect.models;


class Tiers extends Model {
    public var customer(default, null): TierAccount;
    public var tier1(default, null): TierAccount;
    public var tier2(default, null): TierAccount;


    public function new() {
        this._setFieldClassNames([
            'customer' => 'TierAccount',
            'tier1' => 'TierAccount',
            'tier2' => 'TierAccount',
        ]);
    }
}
