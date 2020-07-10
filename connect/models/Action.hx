/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

class Action extends IdModel {
    /** Name field of Action. **/
    public var name: String;

    /** The action field of the Action table **/
    public var action: String;

    /** Only supported type is button for now. **/
    public var type: String;

    /** A description of the action, describing the operation that will be performed. **/
    public var description: String;

    /** Specifies all constrains applied on the action. One of: asset, tier-1, tier-2. **/
    public var scope: String;

    /** Events occured on the action. **/
    public var events: Events;
}
