/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

class UsageRecord extends Model {
    public var recordId: String;
    public var itemSearchCriteria: String;
    public var itemSearchValue: String;
    public var quantity: Int;
    public var startTimeUtc: String;
    public var endTimeUtc: String;
    public var assetSearchCriteria: String;
    public var assetSearchValue: String;
}
