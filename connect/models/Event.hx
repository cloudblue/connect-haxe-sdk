package connect.models;


class Event extends Model {
    public var at(default, null): String;
    public var by(default, null): User;

    public function new() {
        this._setFieldClassNames([
            'by' => 'User'
        ]);
    }
}
