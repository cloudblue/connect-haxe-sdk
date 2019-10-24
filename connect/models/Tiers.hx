package connect.models;


/**
    Tiers object.
**/
class Tiers extends Model {
    /** Customer Level TierAccount Object. **/
    public var customer: TierAccount;


    /** Level 1 TierAccount Object. **/
    public var tier1: TierAccount;


    /** Level 2 TierAccount Object. **/
    public var tier2: TierAccount;


    public function new() {
        super();
        this._setFieldClassNames([
            'customer' => 'TierAccount',
            'tier1' => 'TierAccount',
            'tier2' => 'TierAccount',
        ]);
    }
}
