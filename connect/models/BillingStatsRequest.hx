/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

class BillingStatsRequest extends IdModel {
    /** One of: provider, vendor. **/
    public var type: String;
    public var period: Period;
}
