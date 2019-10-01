package connect;


class Util {
    public static function jsonToCollectionOrDictionary(x: Dynamic): Dynamic {
        switch (Type.typeof(x)) {
            case TClass(Array):
                var arr: Array<Dynamic> = x;
                var col = new Collection<Dictionary>();
                for (elem in arr) {
                    col.push(jsonToCollectionOrDictionary(elem));
                }
                return col;
            case TObject:
                var dict = new Dictionary();
                var fields = Reflect.fields(x);
                for (field in fields) {
                    dict.set(field, jsonToCollectionOrDictionary(Reflect.field(x, field)));
                }
                return dict;
            default:
                return x;
        }
    }
}
