package connect.models;


/**
    Download link for a product.
**/
class DownloadLink extends Model {
    /** Link title. **/
    public var title: String;


    /** Link URL. **/
    public var url: String;


    /** Link visibility. One of: admin, user. **/
    public var visibleFor: String;
}
