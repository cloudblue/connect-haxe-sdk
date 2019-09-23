package connect.api;

import haxe.ds.StringMap;


class QueryParams {
    public function new() {
        this.map = new StringMap<String>();
    }


    public function param(name: String, value: String): QueryParams {
        this.map.set(name, value);
        return this;
    }


    public function keys(): Iterator<String> {
        return this.map.keys();
    }


    public function get(name: String): String {
        return this.map.get(name);
    }

    public function toString(): String {
        var params = [for (key in this.keys()) key].map(function (key) {
            return key + '=' + this.get(key);
        });
        return (params.length > 0) ? ('?' + params.join('&')) : '';
    }


    private var map(default, null): StringMap<String>;
}
