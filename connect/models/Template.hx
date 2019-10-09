package connect.models;


/**
    A Template of a Product.
**/
class Template extends IdModel {
    /** Title of `tihs` Template. **/
    public var title(default, null): String;

    /** Body of `this` Template. **/
    public var body(default, null): String;
}