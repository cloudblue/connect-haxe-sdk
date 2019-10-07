package connect.models;


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

    public function new() {
        super();
        this._setFieldClassNames([
            'parent' => 'Category',
            'children' => 'Category'
        ]);
    }
}