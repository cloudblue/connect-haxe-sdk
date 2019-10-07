package connect.models;


/**
    Download link for a product.
**/
class DownloadLink extends Model {
    /** Link title. **/
    public var title(default, null): String;


    /** Link URL. **/
    public var url(default, null): String;

    /** Link visibility. One of: admin, user. **/
    public var visibleFor(default, null): String;
}
