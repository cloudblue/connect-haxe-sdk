package connect.models;


class Constraints extends Model {
    public var hidden(default, null): Bool;
    public var required(default, null): Bool;
    public var choices(default, null): Collection<Choice>;
    public var unique(default, null): Bool;
}
