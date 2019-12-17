package connect.models;

class UsageRecord extends Model {
    public var recordId: String;
    public var itemSearchCriteria: String;
    public var itemSearchValue: String;
    public var quantity: Int;
    public var startTimeUtc: String;
    public var endTimeUtc: String;
    public var assetSearchCriteria: String;
    public var assetSearchValue: String;
}
