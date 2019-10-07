package connect.models;


/**
    Product configurations.
**/
class Configurations extends Model {
    /** Is suspend and resume supported for the product? **/
    public var suspendResumeSupported(default, null): Bool;

    /** Does the product require reseller information? **/
    public var requiresResellerInformation(default, null): Bool;
}
