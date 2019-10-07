package connect.models;


/**
    Represents basic marketing information about salable items, parameters, configurations,
    latest published version and connections.

    It contains basic product information like name, description and logo, along with the latest
    published version details. So in a single point we can say a single product object always
    represent the latest published version of that product.
**/
class Product extends IdModel {
    /** Product name. **/
    public var name(default, null): String;


    /** Product icon URI. **/
    public var icon(default, null): String;


    /** Short description of `this` Product. **/
    public var shortDescription(default, null): String;


    /** Detailed description of `this` Product. **/
    public var detailedDescription(default, null): String;


    /** Version of `this` Product. **/
    public var version(default, null): String;


    /** Date of publishing. **/
    public var publishedAt(default, null): String;


    /** Product configurations. **/
    public var configurations(default, null): Configurations;


    /** Customer UI Settings. **/
    public var customerUiSettings(default, null): CustomerUiSettings;


    /** Product Category. **/
    public var category(default, null): Category;


    /** Product owner Account. **/
    public var owner(default, null): Account;


    /** true if version is latest or for master versions without versions, false otherwise. **/
    public var latest(default, null): Bool;
    public var stats(default, null): ProductStats;


    public function new() {
        super();
        this._setFieldClassNames([
            'owner' => 'Account',
            'stats' => 'ProductStats'
        ]);
    }
}
