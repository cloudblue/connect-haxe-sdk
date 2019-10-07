package connect.models;


/**
    Configuration Phase Parameter Context-Bound Data Object. To be used in parameter contexts:

    - Asset.
    - Fulfillment.
    - TierConfig.
    - TierConfigRequest.
**/
class Configuration extends Model {
    /** The collection of parameters. **/
    public var params(default, null): Collection<Param>;
}
