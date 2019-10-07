package connect.models;


/**
    Associates a `Hub` with an external id.
**/
class ExtIdHub extends Model {
    /** Hub. **/
    public var hub(default, null): Hub;


    /** External id. **/
    public var externalId(default, null): String;
}
