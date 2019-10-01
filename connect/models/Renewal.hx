package connect.models;


class Renewal extends Model {
    public var from(default, null): String;
    public var to(default, null): String;
    public var periodDelta(default, null): Int;
    public var periodUom(default, null): String;
}
