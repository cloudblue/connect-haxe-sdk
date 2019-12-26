/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Hub stats.
**/
class HubStats extends Model {
    /** Number of connections active for the Hub. **/
    public var connections: Int;


    /** Number of marketplaces for the Hub. **/
    public var marketplaces: Int;
}
