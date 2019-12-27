/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Person of contact.
**/
class Contact extends Model {
    /** First name. **/
    public var firstName: String;


    /** Last name. **/
    public var lastName: String;


    /** Email address. **/
    public var email: String;


    /** Phone number. **/
    public var phoneNumber: PhoneNumber;
}
