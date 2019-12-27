/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    A value choice for a parameter.
**/
class Choice extends Model {
    /** The value of `this` Choice. **/
    public var value: String;

    /** The label shown to the user in the dropdown selector. **/
    public var label: String;
}
