package connect.models;

import connect.api.QueryParams;


/**
    Represents a product category.
**/
class Category extends IdModel {
    /** Category name. **/
    public var name(default, null): String;


    /** Reference to parent category. **/
    public var parent(default, null): Category;


    /** Collection of children categories. **/
    public var children(default, null): Collection<Category>;


    /** Product family. **/
    public var family(default, null): Family;


    /**
        Lists all Categories that match the given filters. Supported filters are:

        - family.id
        - parent.id

        @returns A Collection of Categories.
    **/
    public static function list(?filters: QueryParams) : Collection<Category> {
        var categories = Environment.getGeneralApi().listCategories(filters);
        return Model.parseArray(Category, categories);
    }


    /** @returns The Category with the given id, or `null` if it was not found. **/
    public static function get(id: String): Category {
        try {
            var category = Environment.getGeneralApi().getCategory(id);
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
