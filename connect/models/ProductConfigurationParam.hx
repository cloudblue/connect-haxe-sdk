/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Representation of Configuration Phase Parameter (CPP) Data object.
**/
class ProductConfigurationParam extends Model {
    /** Configuration parameter value. **/
    public var value: String;


    /** Full representation of parameter. **/
    public var parameter: Param;


    /** Reference to Marketplace. **/
    public var marketplace: Marketplace;


    /** Reference to Item. **/
    public var item: Item;


    /** Product events. **/
    public var events: Events;


    // Undocumented fields (they appear in PHP SDK)


    /** Constraints. **/
    public var constraints: Constraints;


    public function new() {
        super();
        this._setFieldClassNames([
            'parameter' => 'Param',
        ]);
    }
}
