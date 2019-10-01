package connect.models;


class CustomerUiSettings extends Model {
    public var description(default, null): String;
    public var gettingStarted(default, null): String;
    public var downloadLinks(default, null): Collection<DownloadLink>;
    public var documents(default, null): Collection<Document>;
}