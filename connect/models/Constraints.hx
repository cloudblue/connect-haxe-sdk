/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.util.Collection;


/**
    Parameter constraints.
**/
class Constraints extends Model {
    /** Is the parameter required? **/
    public var required: Bool;


    /** Is the parameter hidden? **/
    public var hidden: Bool;


    /** Is the constraint unique? **/
    public var unique: Bool;


    /** An explicit way to specify one of the fulfillment parameters as
     * "primary reconciliation ID by the Vendor for the Asset", shown
     * as "asset_recon_id" in the Usage File format.
     */
    public var reconciliation: Bool;


    /** Provider access. One of: view, edit. **/
    public var shared: String;


    /** Minimum characters required. **/
    public var minLength: Int;


    /** Maximum characters allowed. **/
    public var maxLength: Int;


    /** A collection of choices. **/
    public var choices: Collection<Choice>;
}
