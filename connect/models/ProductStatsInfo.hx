/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    Information of some `ProductStats` fields.
**/
class ProductStatsInfo extends Model {
    /** Number of distributions related to the product. **/
    public var distribution: Int;


    /** Number of sourcings related to the product. **/
    public var sourcing: Int;
}
