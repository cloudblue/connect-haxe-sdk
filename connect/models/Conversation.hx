package connect.models;


class Conversation extends IdModel {
    public var instanceId(default, null): String;
    public var created(default, null): String;
    public var topic(default, null): String;
    public var messages(default, null): Collection<Message>;
    public var creator(default, null): User;


    public function new() {
        this._setFieldClassNames([
            'creator' => 'User'
        ]);
    }
}