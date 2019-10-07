package connect.models;


/**
    Tiers object.
**/
class Tiers extends Model {
    /** Customer Level TierAccount Object. **/
    public var customer(default, null): TierAccount;


    /** Level 1 TierAccount Object. **/
    public var tier1(default, null): TierAccount;


    /** Level 2 TierAccount Object. **/
    public var tier2(default, null): TierAccount;


    public function new() {
        super();
        this._setFieldClassNames([
            'customer' => 'TierAccount',
            'tier1' => 'TierAccount',
            'tier2' => 'TierAccount',
        ]);
    }
}
