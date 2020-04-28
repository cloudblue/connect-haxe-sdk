/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.util.Collection;


/**
    Parameters are used in product and asset definitions.
**/
class Param extends IdModel {
    /** Name of parameter. **/
    public var name: String;


    /** Title of parameter. **/
    public var title: String;


    /** Description of parameter. **/
    public var description: String;


    /** Type of parameter. **/
    public var type: String;


    /** Hint for parameter value. **/
    public var hint: String;


    /** Placeholder for parameter. **/
    public var placeholder: String;


    /** Value of parameter. **/
    public var value: String;


    /** Error indicated for parameter. **/
    public var valueError: String;


    /** Collections of string choices for parameter. **/
    public var valueChoice: Collection<String>;


    /** Parameter constraints. **/
    public var constraints: Constraints;


    /** Provider access. One of: view, edit. **/
    public var shared: String;


    /** Collection of available dropdown choices for parameter. **/
    public var valueChoices: Collection<Choice>;


    /** Events. **/
    public var events: Events;


    // Undocumented fields (they appear in PHP SDK)


    /** Scope of parameter. **/
    public var scope: String;


    /** Param phase. **/
    public var phase: String;


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
