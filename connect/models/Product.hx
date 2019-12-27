/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;


/**
    Represents basic marketing information about salable items, parameters, configurations,
    latest published version and connections.

    It contains basic product information like name, description and logo, along with the latest
    published version details. So in a single point we can say a single product object always
    represent the latest published version of that product.
**/
class Product extends IdModel {
    /** Product name. **/
    public var name: String;


    /** Product icon URI. **/
    public var icon: String;


    /** Short description of `this` Product. **/
    public var shortDescription: String;


    /** Detailed description of `this` Product. **/
    public var detailedDescription: String;


    /** Version of `this` Product. **/
    public var version: Int;


    /** Date of publishing. **/
    public var publishedAt: DateTime;


    /** Product configurations. **/
    public var configurations: Configurations;


    /** Customer UI Settings. **/
    public var customerUiSettings: CustomerUiSettings;


    /** Product Category. **/
    public var category: Category;


    /** Product owner Account. **/
    public var owner: Account;


    /** true if version is latest or for master versions without versions, false otherwise. **/
    public var latest: Bool;


    /** Statistics of product use, depends on account of callee. **/
    public var stats: ProductStats;


    // Undocumented fields (they appear in PHP SDK)


    public var status: String;


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
    public static function list(filters: Query) : Collection<Product> {
        final products = Env.getGeneralApi().listProducts(filters);
        return Model.parseArray(Product, products);
    }


    /** @returns The Product with the given id, or `null` if it was not found. **/
    public static function get(id: String): Product {
        try {
            final product = Env.getGeneralApi().getProduct(id);
            return Model.parse(Product, product);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Lists all Actions for the Product that match the given filters. Supported filters are:

        - scope

        @returns A Collection of Actions.
    **/
    public function listActions(filters: Query) : Collection<Action> {
        try {
            final actions = Env.getGeneralApi().listProductActions(this.id, filters);
            return Model.parseArray(Action, actions);
        } catch (ex: Dynamic) {
            return new Collection<Action>();
        }
    }


    /**
        @returns The Action for `this` Product with the given id, or `null` if it was not found.
    **/
    public function getAction(actionId: String): Action {
        try {
            final action = Env.getGeneralApi().getProductAction(this.id, actionId);
            return Model.parse(Action, action);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        @returns The link for `this` Product's Action with the given id,
        or an empty string if it was not found.
    **/
    public function getActionLink(actionId: String): String {
        try {
            return Env.getGeneralApi().getProductActionLink(this.id, actionId);
        } catch (ex: Dynamic) {
            return '';
        }
    }


    /**
        @returns A Collection of Connections for `this` Product.
    **/
    public function getConnections() : Collection<Connection> {
        try {
            final connections = Env.getGeneralApi().getProductConnections(this.id);
            return Model.parseArray(Connection, connections);
        } catch (ex: Dynamic) {
            return new Collection<Connection>();
        }
    }


    /**
        @returns A Collection of Items for `this` Product.
    **/
    public function getItems() : Collection<Item> {
        try {
            final items = Env.getGeneralApi().getProductItems(this.id);
            return Model.parseArray(Item, items);
        } catch (ex: Dynamic) {
            return new Collection<Item>();
        }
    }


    /**
        @returns A Collection of Params for `this` Product.
    **/
    public function getParameters() : Collection<Param> {
        try {
            final params = Env.getGeneralApi().getProductParameters(this.id);
            return Model.parseArray(Param, params);
        } catch (ex: Dynamic) {
            return new Collection<Param>();
        }
    }


    /**
        @returns A Collection of Templates for `this` Product.
    **/
    public function getTemplates() : Collection<Template> {
        try {
            final templates = Env.getGeneralApi().getProductTemplates(this.id);
            return Model.parseArray(Template, templates);
        } catch (ex: Dynamic) {
            return new Collection<Template>();
        }
    }


    /**
        @returns A Collection of Product versions for `this` Product.
    **/
    public function getVersions() : Collection<Product> {
        try {
            final versions = Env.getGeneralApi().getProductVersions(this.id);
            return Model.parseArray(Product, versions);
        } catch (ex: Dynamic) {
            return new Collection<Product>();
        }
    }


    /**
        @returns The version for `this` Product with the given value, or `null` if it was not found.
    **/
    public function getVersion(version: Int): Product {
        try {
            final version = Env.getGeneralApi().getProductVersion(this.id, version);
            return Model.parse(Product, version);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        @returns The Collection of Actions for `this` Product version.
    **/
    public function getVersionActions(version: Int): Collection<Action> {
        try {
            final actions = Env.getGeneralApi()
                .getProductVersionActions(this.id, version);
            return Model.parseArray(Action, actions);
        } catch (ex: Dynamic) {
            return new Collection<Action>();
        }
    }


    /**
        @returns The specified Action for `this` Product version, or `null` if it was not found.
    **/
    public function getVersionAction(version: Int, actionId: String): Action {
        try {
            final action = Env.getGeneralApi()
                .getProductVersionAction(this.id, version, actionId);
            return Model.parse(Action, action);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        @returns The link for `this` Product version's Action with the given id,
        or an empty string if it was not found.
    **/
    public function getVersionActionLink(version: Int, actionId: String): String {
        try {
            return Env.getGeneralApi()
                .getProductVersionActionLink(this.id, version, actionId);
        } catch (ex: Dynamic) {
            return '';
        }
    }


    /**
        @returns A Collection of Items for `this` Product version.
    **/
    public function getVersionItems(version: Int) : Collection<Item> {
        try {
            final items = Env.getGeneralApi().getProductVersionItems(this.id, version);
            return Model.parseArray(Item, items);
        } catch (ex: Dynamic) {
            return new Collection<Item>();
        }
    }


    /**
        @returns A Collection of Params for `this` Product version.
    **/
    public function getVersionParameters(version: Int) : Collection<Param> {
        try {
            final params = Env.getGeneralApi().getProductVersionParameters(this.id, version);
            return Model.parseArray(Param, params);
        } catch (ex: Dynamic) {
            return new Collection<Param>();
        }
    }


    /**
        @returns A Collection of Templates for `this` Product version.
    **/
    public function getVersionTemplates(version: Int) : Collection<Template> {
        try {
            final templates = Env.getGeneralApi().getProductVersionTemplates(this.id, version);
            return Model.parseArray(Template, templates);
        } catch (ex: Dynamic) {
            return new Collection<Template>();
        }
    }


    /**
        Lists all ProductConfigurationParams that match the given filters. Supported filters are:

        - parameter.id
        - parameter.title
        - parameter.scope
        - marketplace.id
        - marketplace.name
        - item.id
        - item.name
        - value

        @returns A Collection of ProductConfigurationParams for `this` Product.
    **/
    public function listConfigurations(filters: Query) : Collection<ProductConfigurationParam> {
        try {
            final templates = Env.getGeneralApi().listProductConfigurations(this.id, filters);
            return Model.parseArray(ProductConfigurationParam, templates);
        } catch (ex: Dynamic) {
            return new Collection<ProductConfigurationParam>();
        }
    }


    /**
        Creates or updates a ProductConfigurationParam.

        @returns The created or updated ProductConfigurationParam for `this` Product,
        or `null` if there was a problem.
    **/
    public function setConfigurationParam(param: ProductConfigurationParam) : ProductConfigurationParam {
        try {
            final param = Env.getGeneralApi().setProductConfigurationParam(this.id, param.toString());
            return Model.parse(ProductConfigurationParam, param);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        @returns A Collection of Agreements for `this` Product.
    **/
    public function listAgreements(filters: Query) : Collection<Agreement> {
        try {
            final agreements = Env.getGeneralApi().listProductAgreements(this.id, filters);
            return Model.parseArray(Agreement, agreements);
        } catch (ex: Dynamic) {
            return new Collection<Agreement>();
        }
    }


    /**
        Lists all Media that match the given filters. Supported filters are:

        - id
        - position
        - type
        - url

        @returns A Collection of Media for `this` Product.
    **/
    public function listMedia(filters: Query) : Collection<Media> {
        try {
            final media = Env.getGeneralApi().listProductMedia(this.id, filters);
            return Model.parseArray(Media, media);
        } catch (ex: Dynamic) {
            return new Collection<Media>();
        }
    }


    /**
        Create a new media for `this` Product.

        @returns The created Media object, or `null` if it could not be created.
    **/
    public function createMedia() : Media {
        try {
            final media = Env.getGeneralApi().createProductMedia(this.id);
            return Model.parse(Media, media);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        @returns The Media for `this` Product with the given id, or `null` if it was not found.
    **/
    public function getMedia(mediaId: String): Media {
        try {
            final media = Env.getGeneralApi().getProductMedia(this.id, mediaId);
            return Model.parse(Media, media);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Updates a Media of `this` Product.

        @returns The updated Media for `this` Product, or `null` if there was a problem.
    **/
    public function updateMedia(media: Media) : Media {
        try {
            final updated = Env.getGeneralApi().updateProductMedia(this.id, media.id, media.toString());
            return Model.parse(Media, updated);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Deletes a Media of `this` Product.

        @returns The deleted Media for `this` Product, or `null` if there was a problem.
    **/
    public function deleteMedia(mediaId: String) : Media {
        try {
            final media = Env.getGeneralApi().deleteProductMedia(this.id, mediaId);
            return Model.parse(Media, media);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'publishedAt' => 'DateTime',
            'owner' => 'Account',
            'stats' => 'ProductStats'
        ]);
    }
}
