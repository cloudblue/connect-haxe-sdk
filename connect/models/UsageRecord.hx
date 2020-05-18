/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.util.DateTime;


class UsageRecord extends Model {
    /** Unique identifier of the usage record. **/
    public var recordId: String;


    /** Optional note. **/
    public var recordNote: String;


    /** Macro that will be used to find out respective item in product. **/
    public var itemSearchCriteria: String;


    /** Value that will be used to identify item within product with the help of filter specified on `itemSearchCriteria`. **/
    public var itemSearchValue: String;


    /** Usage amount corresponding to a item of an asset. Only needed for CR, PR and TR Schemas. **/
    public var amount: Null<Float>;


    /** Usage quantity. **/
    public var quantity: Null<Float>;


    /** Start time. **/
    public var startTimeUtc: DateTime;


    /** End time. **/
    public var endTimeUtc: DateTime;


    /** Macro that will be used to find out respective asset belonging to the product. **/
    public var assetSearchCriteria: String;


    /** Value that will be used to identify Asset belonging to the product with the help of filter specified on `assetSearchCriteria`. **/
    public var assetSearchValue: String;


    /**
     * Item name to which usage record belongs to, only for reporting items that was not part of product definition.
     * Items are reported and created dynamically.
     */
    public var itemName: String;


    /**
     * Item MPN to which usage record belongs to, only for reporting items that was not part of product definition.
     * Items are reported and created dynamically.
     */
    public var itemMpn: String;


    /**
     * Only for reporting items that was not part of product definition.
     * Items are reported and created dynamically.
     */
    public var itemUnit: String;


    /**
     * Precision of the item for which usage record belong to.
     * Input data should be one of: integer, decimal(1), decimal(2), decimal(4), decimal(8).
     * Only for reporting items that was not part of product definition.
     * Items are reported and created dynamically.
     */
    public var itemPrecision: String;


    /**
     * Category id to link this usage record with a category.
     */
    public var categoryId: String;


    /**
     * Optional: Asset reconciliation ID provided by vendor.
     * This value comes from a parameter value of the asset that is marked as recon id by vendor.
     */
    public var assetReconId: String;


    /** Tier level specified for linking usage record with a tier account of Asset in case of TR schema. **/
    public var tier: Int;


    public function new() {
        super();
        this._setFieldClassNames([
            'startTimeUtc' => 'DateTime',
            'endTimeUtc' => 'DateTime',
        ]);
    }
}
