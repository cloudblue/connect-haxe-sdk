package connect;

import haxe.extern.EitherType;


class Util {
    public static function toDictionary(obj: Dynamic): Dictionary {
        return toDictionary_r(obj);
    }


    public static function toObject(dict: Dictionary): Dynamic {
        return toObject_r(dict);
    }


    private static function toDictionary_r(x: Dynamic)
            : EitherType<Collection<Dictionary>, Dictionary> {
        switch (Type.typeof(x)) {
            case TClass(Array):
                var arr: Array<Dynamic> = x;
                var col = new Collection<Dictionary>();
                for (elem in arr) {
                    col.push(toDictionary_r(elem));
                }
                return col;
            case TObject:
                var dict = new Dictionary();
                var fields = Reflect.fields(x);
                for (field in fields) {
                    dict.set(field, toDictionary_r(Reflect.field(x, field)));
                }
                return dict;
            default:
                return x;
        }
    }


    private static function toObject_r(x: Dynamic) : EitherType<Array<Dynamic>, Dynamic> {
        switch (Type.typeof(x)) {
            case TClass(Collection):
                var col: Collection<Dictionary> = x;
                var arr = new Array<Dynamic>();
                for (elem in col) {
                    arr.push(toObject_r(elem));
                }
                return arr;
            case TClass(Dictionary):
                var dict: Dictionary = x;
                var obj = {};
                var keys = dict.keys();
                for (key in keys) {
                    Reflect.setField(obj, key, toObject_r(dict.get(key)));
                }
                return obj;
            default:
                return x;
        }
    }
}
