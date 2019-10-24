package connect.api;

import haxe.ds.StringMap;


class QueryParams {
    public function new() {
        this.map = new StringMap<String>();
    }


    public function keys(): Iterator<String> {
        return this.map.keys();
    }


    public function get(name: String): String {
        return this.map.get(name);
    }


    public function set(name: String, value: String): QueryParams {
        this.map.set(name, value);
        return this;
    }


    public function toString(): String {
        var paramsArr = [for (key in this.keys()) key].map(function (key) {
            var encodedKey = StringTools.urlEncode(key);
            var encodedValue = StringTools.urlEncode(this.get(key));
            return encodedKey + '=' + encodedValue;
        });
        return (paramsArr.length > 0) ? ('?' + paramsArr.join('&')) : '';
    }


    private var map: StringMap<String>;
}
