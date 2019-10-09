package connect.models;


/**
    Representation of Configuration Phase Parameter (CPP) Data object.
**/
class ProductConfigurationParam extends Model {
    /** Configuration parameter value. **/
    public var value(default, null): String;


    /** Full representation of parameter. **/
    public var parameter(default, null): Param;


    /** Reference to Marketplace. **/
    public var marketplace(default, null): Marketplace;


    /** Reference to Item. **/
    public var item(default, null): Item;


    /** Product events. **/
    public var events(default, null): Events;


    // Undocumented fields (they appear in PHP SDK)


    /** Constraints. **/
    public var constraints(default, null): Constraints;


    public function new() {
        super();
        this._setFieldClassNames([
            'parameter' => 'Param',
        ]);
    }
}
