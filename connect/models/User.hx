/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Represents a user within the platform.
**/
class User extends IdModel {
    /** User name. **/
    public var name: String;


    /** User email. **/
    public var email: String;
}
