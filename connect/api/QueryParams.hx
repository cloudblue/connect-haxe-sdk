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


    private var map(default, null): StringMap<String>;
}
