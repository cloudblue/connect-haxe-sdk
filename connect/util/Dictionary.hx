/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import haxe.ds.StringMap;
import haxe.extern.EitherType;


/**
    A Dictionary allows mapping of String keys to arbitrary values. If the value of a key is given
    one type and then retrieved with a different type (for example, `setInt` ... `getObject`), the
    result is unspecified.
**/
class Dictionary extends Base {
    /**
        Creates a new Dictionary.
    **/
    public function new() {
        this.map = new StringMap<Dynamic>();
    }


    /**
        Removes all keys from `this` Dictionary.
    **/
    public function clear(): Void {
        return map.clear();
    }


    /**
        Returns a shallow copy of `this` Dictionary.
        The order of values is undefined.
    **/
    public function copy(): Dictionary {
        final cp = new Dictionary();
        for (key in this.keys()) {
            cp.set(key, this.get(key));
        }
        return cp;
    }


    /**
        Returns true if `key` has a mapping, false otherwise.
        If `key` is `null`, the result is unspecified.
    **/
    public function exists(key: String): Bool {
        return map.exists(key);
    }


    /**
        Returns the current mapping of `key` as an Object.

        If no such mapping exists, null is returned.

        Note that a check like `dict.get(key) == null` can hold for two reasons:

        1. The dictionary has no mapping for `key`
        2. The dictionary has a mapping with a value of `null`

        If it is important to distinguish these cases, `exists()` should be used.
        
        If `key` is null, the result is unspecified.
    **/
    public function get(key: String): Dynamic {
        return map.get(key);
    }


    /**
        Returns the current mapping of `key` as a Bool.

        If no such mapping exists, false is returned.

        Note that a check like `dict.get(key) == false` can hold for two reasons:

        1. The dictionary has no mapping for `key`
        2. The dictionary has a mapping with a value of `false`

        If it is important to distinguish these cases, `exists()` should be used.

        If `key` is null, the result is unspecified.
    **/
    public function getBool(key: String): Bool {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return false;
        }
    }


    /**
        Returns the current mapping of `key` as an Int.

        If no such mapping exists, 0 is returned.

        Note that a check like `dict.get(key) == 0` can hold for two reasons:

        1. The dictionary has no mapping for `key`
        2. The dictionary has a mapping with a value of `0`

        If it is important to distinguish these cases, `exists()` should be used.
        
        If `key` is null, the result is unspecified.
    **/
    public function getInt(key: String): Int {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return 0;
        }
    }


    /**
        Returns the current mapping of `key` as a Float.

        If no such mapping exists, 0.0 is returned.

        Note that a check like `dict.get(key) == 0.0` can hold for two reasons:

        1. The dictionary has no mapping for `key`
        2. The dictionary has a mapping with a value of `0.0`

        If it is important to distinguish these cases, `exists()` should be used.
        
        If `key` is null, the result is unspecified.
    **/
    public function getFloat(key: String): Float {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return 0.0;
        }
    }


    /**
        Returns the current mapping of `key` as a String.

        If no such mapping exists, an empty string is returned.

        Note that a check like `dict.get(key) == ""` can hold for two reasons:

        1. The dictionary has no mapping for `key`
        2. The dictionary has a mapping with a value of `""`

        If it is important to distinguish these cases, `exists()` should be used.
        
        If `key` is null, the result is unspecified.
    **/
    public function getString(key: String): String {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return '';
        }
    }


    /**
        Returns an Iterator over the values of `this` Dictionary.
        The order of values is undefined.
    **/
    public function iterator(): Iterator<Dynamic> {
        return map.iterator();
    }


    /**
        Returns an Iterator over the keys of `this` Dictionary.
        The order of keys is undefined.
    **/
    public function keys(): Iterator<String> {
        return map.keys();
    }

    /**
        Returns true if `this` Dictionary has not keys
        @return Bool
     **/
    public function isEmpty():Bool{
        return map.keys() == null || !map.keys().hasNext();
    }

    /**
        Removes the mapping of `key` and returns true if such a mapping existed,
        false otherwise.
        If `key` is `null`, the result is unspecified.
    **/
    public function remove(key: String): Bool {
        return map.remove(key);
    }


    /**
        Maps `key` to a `value`.
        If `key` already has a mapping, the previous value disappears.
        If `key` is null, the result is unspecified.
    **/
    public function set(key: String, value: Dynamic): Dictionary {
        map.set(key, value);
        return this;
    }


    /**
        Maps `key` to a Bool `value`.
        If `key` already has a mapping, the previous value disappears.
        If `key` is null, the result is unspecified.
    **/
    public function setBool(key: String, x: Bool): Dictionary {
        return this.set(key, x);
    }


    /**
        Maps `key` to an Int `value`.
        If `key` already has a mapping, the previous value disappears.
        If `key` is null, the result is unspecified.
    **/
    public function setInt(key: String, x: Int): Dictionary {
        return this.set(key, x);
    }


    /**
        Maps `key` to a Float `value`.
        If `key` already has a mapping, the previous value disappears.
        If `key` is null, the result is unspecified.
    **/
    public function setFloat(key: String, x: Float): Dictionary {
        return this.set(key, x);
    }


    /**
        Maps `key` to a String `value`.
        If `key` already has a mapping, the previous value disappears.
        If `key` is null, the result is unspecified.
    **/
    public function setString(key: String, x: String): Dictionary {
        return this.set(key, x);
    }


    /**
        Returns a JSON string representation of `this` Dictionary.
    **/
    public function toString(): String {
        return haxe.Json.stringify(this.toObject());
    }


    /**
        Returns a dynamic object with the same contents as the `this` Dictionary.
        Dynamic object is a native Haxe feature, and can be hard to work with in the target
        languages, so this method exists so you can work with their data using the
        `Dictionary` methods and then convert them back to dynamic objects.

        All collections within the object will be converted to arrays.

        Classes in the `connect.api` package work with dynamic objects
    **/
    public function toObject(): Dynamic {
        return toObject_r(this);
    }


    /**
        Returns a Dictionary with the same contents as the given dynamic object.
        Dynamic object is a native Haxe feature, and can be hard to work with in the target
        languages, so this method exists so you can work with their data using the
        `Dictionary` methods.

        All arrays within the object will be converted to collections.

        Classes in the `connect.api` package work with dynamic objects.
    **/
    public static function fromObject(obj: Dynamic): Dictionary {
    #if python
        if (python.Syntax.code("isinstance({0}, dict)", obj)) {
            obj = python.Lib.dictToAnon(obj);
        }
    #end
        return fromObject_r(obj);
    }


    private final map: StringMap<Dynamic>;


    private static function toObject_r(x: Dynamic) : EitherType<Array<Dynamic>, Dynamic> {
        switch (Type.typeof(x)) {
            case TClass(Collection):
                final col: Collection<Dynamic> = x;
                final arr = new Array<Dynamic>();
                for (elem in col) {
                    arr.push(toObject_r(elem));
                }
                return arr;
            case TClass(Dictionary):
                final dict: Dictionary = x;
                final obj = {};
                final keys = dict.keys();
                for (key in keys) {
                    Reflect.setField(obj, key, toObject_r(dict.get(key)));
                }
                return obj;
            default:
                final classObj = Type.getClass(x);
                final instanceFields = (classObj != null)
                    ? Type.getInstanceFields(classObj)
                    : [];
                final hasToObject = instanceFields.indexOf('toObject') > -1;
                return hasToObject ? x.toObject() : x;
        }
    }


    private static function fromObject_r(x: Dynamic)
            : Dynamic {
        switch (Type.typeof(x)) {
            case TClass(Array):
                final arr: Array<Dynamic> = x;
                final col = new Collection<Dynamic>();
                for (elem in arr) {
                    col.push(fromObject_r(elem));
                }
                return col;
            case TObject:
                final dict = new Dictionary();
                final fields = Reflect.fields(x);
                for (field in fields) {
                    dict.set(field, fromObject_r(Reflect.field(x, field)));
                }
                return dict;
            default:
            #if python
                if (python.Syntax.code("isinstance({0}, dict)", x)) {
                    return fromObject_r(python.Lib.dictToAnon(x));
                }
            #end
                return x;
        }
    }
}
