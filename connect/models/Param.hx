/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Parameters are used in product and asset definitions.
**/
class Param extends IdModel {
    /** Name of parameter. **/
    public var name: String;


    /** Description of parameter. **/
    public var description: String;


    /** Type of parameter. **/
    public var type: String;


    /** Value of parameter. **/
    public var value: String;


    /** Error indicated for parameter. **/
    public var valueError: String;


    /** Collections of string choices for parameter. **/
    public var valueChoice: Collection<String>;


    // Undocumented fields (they appear in PHP SDK)


    /** Title for parameter. **/
    public var title: String;


    /** Scope of parameter. **/
    public var scope: String;


    /** Parameter constraints. **/
    public var constraints: Constraints;


    /** Collection of available dropdown choices for parameter. **/
    public var valueChoices: Collection<Choice>;


    /** Param phase. **/
    public var phase: String;


    /** Events. **/
    public var events: Events;


    /** Marketplace. **/
    public var marketplace: Marketplace;


    public function new() {
        super();
        this._setFieldClassNames([
            'valueChoice' => 'String',
            'valueChoices' => 'Choice',
        ]);
    }
}
