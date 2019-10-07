package connect.models;


/**
    Customer Ui Settings for a product.
**/
class CustomerUiSettings extends Model {
    /** Description text. **/
    public var description(default, null): String;


    /** Getting started text. **/
    public var gettingStarted(default, null): String;


    /** Collection of download links. **/
    public var downloadLinks(default, null): Collection<DownloadLink>;


    /** Collection of documents. **/
    public var documents(default, null): Collection<Document>;
}
