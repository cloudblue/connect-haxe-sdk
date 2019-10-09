package connect;

import haxe.ds.StringMap;
import haxe.extern.EitherType;


/**
    A Dictionary allows mapping of String keys to arbitrary values. If the value of a key is given
    one type and then retrieved with a different type (for example, `setInt` ... `getObject`), the
    result is unspecified.
**/
class Dictionary extends StringMap<Dynamic> {
    /**
        Creates a new Dictionary.
    **/
    public function new() {
        super();
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
		Returns the current mapping of `key` as an Object.

		If no such mapping exists, null is returned.

		Note that a check like `dict.get(key) == null` can hold for two reasons:

		1. The dictionary has no mapping for `key`
		2. The dictionary has a mapping with a value of `null`

		If it is important to distinguish these cases, `exists()` should be used.
        
		If `key` is null, the result is unspecified.
	**/
    public function getObject(key: String): Dynamic {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return null;
        }
    }


    /**
		Maps `key` to a Bool `value`.
		If `key` already has a mapping, the previous value disappears.
		If `key` is null, the result is unspecified.
	**/
    public function setBool(key: String, x: Bool): Dictionary {
        this.set(key, x);
        return this;
    }


    /**
		Maps `key` to an Int `value`.
		If `key` already has a mapping, the previous value disappears.
		If `key` is null, the result is unspecified.
	**/
    public function setInt(key: String, x: Int): Dictionary {
        this.set(key, x);
        return this;
    }


    /**
		Maps `key` to a Float `value`.
		If `key` already has a mapping, the previous value disappears.
		If `key` is null, the result is unspecified.
	**/
    public function setFloat(key: String, x: Float): Dictionary {
        this.set(key, x);
        return this;
    }


    /**
		Maps `key` to a String `value`.
		If `key` already has a mapping, the previous value disappears.
		If `key` is null, the result is unspecified.
	**/
    public function setString(key: String, x: String): Dictionary {
        this.set(key, x);
        return this;
    }


    /**
		Maps `key` to an Object `value`.
		If `key` already has a mapping, the previous value disappears.
		If `key` is null, the result is unspecified.
	**/
    public function setObject(key: String, x: Dynamic): Dictionary {
        this.set(key, x);
        return this;
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
        return fromObject_r(obj);
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


    private static function fromObject_r(x: Dynamic)
            : EitherType<Collection<Dictionary>, Dictionary> {
        switch (Type.typeof(x)) {
            case TClass(Array):
                var arr: Array<Dynamic> = x;
                var col = new Collection<Dictionary>();
                for (elem in arr) {
                    col.push(fromObject_r(elem));
                }
                return col;
            case TObject:
                var dict = new Dictionary();
                var fields = Reflect.fields(x);
                for (field in fields) {
                    dict.set(field, fromObject_r(Reflect.field(x, field)));
                }
                return dict;
            default:
                return x;
        }
    }
}
