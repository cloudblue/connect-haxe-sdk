/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
 * Indicates whether the product is available in wholesale catalog.
 * Object appears when product can be published.
 */
class ListingSourcing extends Model {
    /** Sourcing Agreement Reference. **/
    public var agreement: Agreement;

    /** Indicates whether it is published in the wholesale catalog. **/
    public var published: Bool;
}
