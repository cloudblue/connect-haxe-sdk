/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Represents the information of a contact.
**/
class ContactInfo extends Model {
    /** Street address, first line. **/
    public var addressLine1: String;


    /** Street address, second line. **/
    public var addressLine2: String;


    /** Country code. **/
    public var country: String;


    /** State name. **/
    public var state: String;


    /** City name. **/
    public var city: String;


    /** Postal ZIP code. **/
    public var postalCode: String;


    /** Person of contact. **/
    public var contact: Contact;
}
