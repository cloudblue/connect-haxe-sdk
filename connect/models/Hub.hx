/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;


/**
    A Hub.
**/
class Hub extends IdModel {
    /** Hub name. **/
    public var name: String;


    /** Reference to the company Account the hub belongs to. **/
    public var company: Account;


    /** Hub description (Markdown text). **/
    public var description: String;


    /** Hub instance. **/
    public var instance: Instance;


    /** Events occurred on Hub. **/
    public var events: Events;


    /** Hub stats. **/
    public var stats: HubStats;


    public function new() {
        super();
        this._setFieldClassNames([
            'company' => 'Account',
            'stats' => 'HubStats'
        ]);
    }
}
