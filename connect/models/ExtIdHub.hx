/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Associates a `Hub` with an external id.
**/
class ExtIdHub extends Model {
    /** Hub. **/
    public var hub: Hub;


    /** External id. **/
    public var externalId: String;
}
