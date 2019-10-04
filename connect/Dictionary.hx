package connect;

import haxe.ds.StringMap;


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
}
