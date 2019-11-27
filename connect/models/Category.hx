package connect.models;

import connect.api.Query;


/**
    Represents a product category.
**/
class Category extends IdModel {
    /** Category name. **/
    public var name: String;


    /** Reference to parent category. **/
    public var parent: Category;


    /** Collection of children categories. **/
    public var children: Collection<Category>;


    /** Product family. **/
    public var family: Family;


    /**
        Lists all Categories that match the given filters. Supported filters are:

        - family.id
        - parent.id

        @returns A Collection of Categories.
    **/
    public static function list(filters: Query) : Collection<Category> {
        final categories = Env.getGeneralApi().listCategories(filters);
        return Model.parseArray(Category, categories);
    }


    /** @returns The Category with the given id, or `null` if it was not found. **/
    public static function get(id: String): Category {
        try {
            final category = Env.getGeneralApi().getCategory(id);
            return Model.parse(Category, category);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    public function new() {
        super();
        this._setFieldClassNames([
            'parent' => 'Category',
            'children' => 'Category'
        ]);
    }
}
