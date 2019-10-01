package connect.models;


class Item extends IdModel {
    public var mpn(default, null): String;
    public var quantity(default, null): String;
    public var oldQuantity(default, null): String;
    public var renewal(default, null): Renewal;
    public var params(default, null): Collection<Param>;

    // Undocumented fields (they appear in PHP SDK)

    public var displayName(default, null): String;
    public var globalId(default, null): String;
    public var itemType(default, null): String;
    public var period(default, null): String;
    public var type(default, null): String;
    public var name(default, null): String;
}
