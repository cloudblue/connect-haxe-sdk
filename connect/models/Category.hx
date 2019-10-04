package connect.models;


class Category extends IdModel {
    public var name(default, null): String;
    public var parent(default, null): Category;
    public var children(default, null): Collection<Category>;
    public var family(default, null): Family;

    public function new() {
        super();
        this._setFieldClassNames([
            'parent' => 'Category',
            'children' => 'Category'
        ]);
    }
}