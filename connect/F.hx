package connect;


@:dox(hide)
class F {
    public static function reduce<A, B>(it: Iterable<A>, f: (B, A, Int) -> B, initialValue: B) {
        var value = initialValue;
        var i = 0;
        for (elem in it) {
            value = f(value, elem, i);
            ++i;
        }
    }
}