/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Product configurations.
**/
class Configurations extends Model {
    /** Is suspend and resume supported for the product? **/
    public var suspendResumeSupported: Bool;

    /** Does the product require reseller information? **/
    public var requiresResellerInformation: Bool;
}
