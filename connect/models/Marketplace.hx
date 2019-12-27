/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    An object containing Distribution agreements with exact Hubs, enriched with additional
    information on details about the relation.

    A Marketplace is a way to list Products to specified regions (based on Distribution Agreements)
    and use specific Hubs to provision incoming Fulfillment requests.
**/
class Marketplace extends IdModel {
    /** Marketplace title, unique for an account. **/
    public var name: String;


    /** Markdown text describing the marketplace. **/
    public var description: String;


    /** How many active contracts were signed on the Marketplace. **/
    public var activeContracts: Int;


    /** Image identifying Marketplace object uploaded by user. **/
    public var icon: String;


    /** Provider account - the object owner. **/
    public var owner: Account;


    /** Collection of account-hub relations associated with the Marketplace object. **/
    public var hubs: Collection<ExtIdHub>;


    /**
        Zone where the marketplace is located, there can be following zones:
        AF, NA, OC, AS, EU, SA (It is continents).
    **/
    public var zone: String;


    /** Collection of country objects associated with marketplace. **/
    public var countries: List<Country>;


    /** Is marketplace available for sourcing? **/
    public var sourcing: Bool;


    public function new() {
        super();
        this._setFieldClassNames([
            'hubs' => 'ExtIdHub',
            'countries' => 'Country'
        ]);
    }
}
