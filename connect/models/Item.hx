package connect.models;


/**
    A product item.
**/
class Item extends IdModel {
    /** Item manufacture part number. **/
    public var mpn(default, null): String;


    /** Number of items of the type in the asset ("-1" if unlimited) **/
    public var quantity(default, null): String;


    /** Previous value of quantity. **/
    public var oldQuantity(default, null): String;


    /** Parameters of renewal request (empty for all other types). **/
    public var renewal(default, null): Renewal;


    /** List of Item and Item x Marketplace Configuration Phase Parameter Context-Bound Object. **/
    public var params(default, null): Collection<Param>;


    // Undocumented fields (they appear in PHP SDK)


    /** Display name. **/
    public var displayName(default, null): String;


    /** Global id. **/
    public var globalId(default, null): String;


    /** Item type. **/
    public var itemType(default, null): String;


    /** Period. **/
    public var period(default, null): String;


    /** Type. **/
    public var type(default, null): String;


    /** Name. **/
    public var name(default, null): String;
}
