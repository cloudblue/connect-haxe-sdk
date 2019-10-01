package connect;

import haxe.extern.EitherType;


class Util {
    public static function toDictionary(obj: Dynamic): Dictionary {
        var dict = new Dictionary();
        var fields = Reflect.fields(obj);
        for (field in fields) {
            dict.set(field, toCollectionOrDictionary(Reflect.field(obj, field)));
        }
        return dict;
    }


    private static function toCollectionOrDictionary(x: Dynamic)
            : EitherType<Collection<Dictionary>, Dictionary> {
        switch (Type.typeof(x)) {
            case TClass(Array):
                var arr: Array<Dynamic> = x;
                var col = new Collection<Dictionary>();
                for (elem in arr) {
                    col.push(toCollectionOrDictionary(elem));
                }
                return col;
            case TObject:
                var dict = new Dictionary();
                var fields = Reflect.fields(x);
                for (field in fields) {
                    dict.set(field, toCollectionOrDictionary(Reflect.field(x, field)));
                }
                return dict;
            default:
                return x;
        }
    }
}
