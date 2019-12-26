/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Phone number.
**/
class PhoneNumber extends Model {
    /** Country code. **/
    public var countryCode: String;


    /** Area code. **/
    public var areaCode: String;


    /** Phone number. **/
    public var phoneNumber: String;


    /** Phone extension. **/
    public var extension: String;
}
