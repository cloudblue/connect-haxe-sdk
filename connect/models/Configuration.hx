/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
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
    public var params: Collection<Param>;


    /** @returns The `Param` with the given id, or `null` if it was not found. **/
    public function getParamById(paramId: String): Param {
        final params = this.params.toArray().filter(function(param) {
            return param.id == paramId;
        });
        return (params.length > 0) ? params[0] : null;
    }
}
