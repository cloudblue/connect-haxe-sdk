package connect.models;


/**
    Country data.
**/
class Country extends IdModel {
    /** Country name. **/
    public var name(default, null): String;


    /** Icon path. **/
    public var icon(default, null): String;


    /** Geographical zone. **/
    public var zone(default, null): String;
}
