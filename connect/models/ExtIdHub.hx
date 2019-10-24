package connect.models;


/**
    Associates a `Hub` with an external id.
**/
class ExtIdHub extends Model {
    /** Hub. **/
    public var hub: Hub;


    /** External id. **/
    public var externalId: String;
}
