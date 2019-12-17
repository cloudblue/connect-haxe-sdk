package connect;


/**
    This class adds functional operations missing in Haxe's Lambda class.
**/
@:dox(hide)
class F {
    public static function reduce<A, B>(it: Iterable<A>, f: (B, A, Int, Iterable<A>) -> B, initialValue: B) {
        var value = initialValue;
        var i = 0;
        for (elem in it) {
            value = f(value, elem, i, it);
            ++i;
        }
    }
}
