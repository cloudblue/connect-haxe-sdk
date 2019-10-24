package connect.models;


/**
    Customer Ui Settings for a product.
**/
class CustomerUiSettings extends Model {
    /** Description text. **/
    public var description: String;


    /** Getting started text. **/
    public var gettingStarted: String;


    /** Collection of download links. **/
    public var downloadLinks: Collection<DownloadLink>;


    /** Collection of documents. **/
    public var documents: Collection<Document>;
}
