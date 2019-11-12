package connect;


@:dox(hide)
class Util {
    public static function getDate(): String {
        final date = Date.now();
        return new Date(
            date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(),
            date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()
        ).toString() + ' UTC';
    }
}
