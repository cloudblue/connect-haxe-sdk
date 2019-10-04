package connect;

import haxe.extern.EitherType;


/**
    This class provides utility functions.
**/
class Util {
    /**
        Returns a Dictionary with the same contents as the given dynamic object.
        Dynamic object is a native Haxe feature, and can be hard to work with in the target
        languages, so this method exists so you can work with their data using the
        `Dictionary` methods.

        All arrays within the object will be converted to collections.

        Classes in the `connect.api` package work with dynamic objects.
    **/
    public static function toDictionary(obj: Dynamic): Dictionary {
        return toDictionary_r(obj);
    }


    /**
        Returns a dynamic object with the same contents as the given Dictionary.
        Dynamic object is a native Haxe feature, and can be hard to work with in the target
        languages, so this method exists so you can work with their data using the
        `Dictionary` methods and then convert them back to dynamic objects.

        All collections within the object will be converted to arrays.

        Classes in the `connect.api` package work with dynamic objects
    **/
    public static function toObject(dict: Dictionary): Dynamic {
        return toObject_r(dict);
    }


    /**
        Returns a string with the given text converted from snake_case to camelCase.

        If `capitalizeFirst` is true, then the string is returned as UpperCamelCase.
    **/
    public static function toCamelCase(text: String, capitalizeFirst: Bool = false): String {
        var buffer = new StringBuf();
        var lastWasUnderscore = capitalizeFirst;
        for (i in 0...text.length) {
            var char = lastWasUnderscore ? text.charAt(i).toUpperCase() : text.charAt(i);
            if (char != '_') {
                buffer.add(char);
                lastWasUnderscore = false;
            } else {
                lastWasUnderscore = true;
            }
        }
        return buffer.toString();
    }


    /**
        Returns a string the trailing "s" removed from the given text, if it has one.
    **/
    public static function toSingular(text: String): String {
        if (text.charAt(text.length - 1) == 's') {
            return text.substr(0, text.length - 1);
        } else {
            return text;
        }
    }


    /**
        Returns a string with the given text converted from camelCase or UpperCamelCase to
        snake_case.
    **/
    public static function toSnakeCase(text: String): String {
        var r1 = ~/(.)([A-Z][a-z]+)/g;
        var r2 = ~/([a-z0-9])([A-Z])/g;
        var s1 = r1.replace(text, '$1_$2');
        return r2.replace(s1, '$1_$2').toLowerCase();
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
