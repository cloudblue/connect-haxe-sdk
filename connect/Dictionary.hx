package connect;

import haxe.ds.StringMap;


class Dictionary extends StringMap<Dynamic> {
    public function getBool(key: String): Bool {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return false;
        }
    }


    public function getInt(key: String): Int {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return 0;
        }
    }


    public function getFloat(key: String): Float {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return 0.0;
        }
    }


    public function getString(key: String): String {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return '';
        }
    }


    public function getObject(key: String): Dynamic {
        if (this.exists(key)) {
            return this.get(key);
        } else {
            return null;
        }
    }


    public function setBool(key: String, x: Bool): Dictionary {
        this.set(key, x);
        return this;
    }


    public function setInt(key: String, x: Int): Dictionary {
        this.set(key, x);
        return this;
    }


    public function setFloat(key: String, x: Float): Dictionary {
        this.set(key, x);
        return this;
    }


    public function setString(key: String, x: String): Dictionary {
        this.set(key, x);
        return this;
    }


    public function setObject(key: String, x: Dynamic): Dictionary {
        this.set(key, x);
        return this;
    }
}
