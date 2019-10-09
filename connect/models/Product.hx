package connect.models;

import connect.api.QueryParams;


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


    /** Statistics of product use, depends on account of callee. **/
    public var stats(default, null): ProductStats;


    /**
        Lists all Products that match the given filters. Supported filters are:

        - name
        - category.id (eq)
        - owner.id
        - owner.name
        - version (eq, ne, null)
        - search
        - stats.listings
        - stats.agreements.distribution
        - stats.agreements.sourcing
        - stats.contracts.sourcing
        - stats.contracts.distribution
        - latest (eq, ne)
        - status (Draft)

        @returns A Collection of Products.
    **/
    public static function list(?filters: QueryParams) : Collection<Product> {
        var products = Environment.getGeneralApi().listProducts(filters);
        return Model.parseArray(Product, products);
    }


    /** @returns The Product with the given id, or `null` if it was not found. **/
    public static function get(id: String): Product {
        try {
            var product = Environment.getGeneralApi().getProduct(id);
            return Model.parse(Product, product);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Lists all Actions for the Product that match the given filters. Supported filters are:

        - scope

        @returns A Collection of Products.
    **/
    public function listActions(?filters: QueryParams) : Collection<Action> {
        var actions = Environment.getGeneralApi().listProductActions(this.id, filters);
        return Model.parseArray(Action, actions);
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'owner' => 'Account',
            'stats' => 'ProductStats'
        ]);
    }
}
