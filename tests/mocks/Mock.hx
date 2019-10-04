package tests.mocks;

import connect.Dictionary;
import haxe.ds.StringMap;


class Mock {
    public function new() {
        this.reset();
    }


    public function reset() {
        this.funcCalls = new StringMap<Array<Array<Dynamic>>>();
    }


    public function calledFunction(name: String, args: Array<Dynamic>): Void {
        var argsList = this.funcCalls.exists(name)
            ? this.funcCalls.get(name)
            : [];
        argsList.push(args);
        this.funcCalls.set(name, argsList);
    }


    public function callCount(name: String): Int {
        if (this.funcCalls.exists(name)) {
            return this.funcCalls.get(name).length;
        } else {
            return 0;
        }
    }


    public function callArgs(name: String, callIndex: Int): Array<Dynamic> {
        var funcCalls = this.funcCalls.exists(name) ? this.funcCalls.get(name) : null;
        if (funcCalls != null && callIndex >= 0 && callIndex < funcCalls.length) {
            return funcCalls[callIndex];
        } else {
            return null;
        }
    }


    public static function parseJsonFile(filename: String): Dynamic {
        var content = sys.io.File.getContent(filename);
        return haxe.Json.parse(content);
    }


    private var funcCalls: StringMap<Array<Array<Dynamic>>>;
}
