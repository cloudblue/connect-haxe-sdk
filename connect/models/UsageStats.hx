/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


class UsageStats extends Model {
    public var uploaded: Int;
    public var validated: Int;
    public var pending: Int;
    public var accepted: Int;
    public var closed: Int;
}
