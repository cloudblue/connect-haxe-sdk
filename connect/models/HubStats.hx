package connect.models;


/**
    Hub stats.
**/
class HubStats extends Model {
    /** Number of connections active for the Hub. **/
    public var connections(default, null): Int;


    /** Number of marketplaces for the Hub. **/
    public var marketplaces(default, null): Int;
}
