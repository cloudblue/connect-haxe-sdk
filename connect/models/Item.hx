package connect.models;


/**
    A product item.
**/
class Item extends IdModel {
    /** Item manufacture part number. **/
    public var mpn: String;


    /** Number of items of the type in the asset ("-1" if unlimited) **/
    public var quantity: String;


    /** Previous value of quantity. **/
    public var oldQuantity: String;


    /** Parameters of renewal request (empty for all other types). **/
    public var renewal: Renewal;


    /** List of Item and Item x Marketplace Configuration Phase Parameter Context-Bound Object. **/
    public var params: Collection<Param>;


    // Undocumented fields (they appear in PHP SDK)


    /** Display name. **/
    public var displayName: String;


    /** Global id. **/
    public var globalId: String;


    /** Item type. **/
    public var itemType: String;


    /** Period. **/
    public var period: String;


    /** Type. **/
    public var type: String;


    /** Name. **/
    public var name: String;


    /** @returns The `Param` with the given id, or `null` if it was not found. **/
    public function getParamById(paramId: String): Param {
        final params = this.params.toArray().filter(function(param) {
            return param.id == paramId;
        });
        return (params.length > 0) ? params[0] : null;
    }
}
