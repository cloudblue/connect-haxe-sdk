package connect.models;


class Message extends IdModel {
    public var conversation(default, null): String;
    public var created(default, null): String;
    public var creator(default, null): User;
    public var text(default, null): String;


    public function new() {
        this._setFieldClassNames([
            'creator' => 'User'
        ]);
    }
}
