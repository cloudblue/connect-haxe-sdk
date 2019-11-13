package connect;


@:dox(hide)
class Util {
    public static function getDate(?dateOrNull: Date): String {
        final date = (dateOrNull != null) ? dateOrNull : Date.now();
        return new Date(
            date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(),
            date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()
        ).toString();
    }
}
