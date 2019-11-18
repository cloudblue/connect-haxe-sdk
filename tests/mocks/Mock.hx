package tests.mocks;

import haxe.ds.StringMap;


class Mock {
    public function new() {
        this.reset();
    }


    public function reset() {
        this.funcCalls = new StringMap<Array<Array<Dynamic>>>();
    }


    public function calledFunction(name: String, args: Array<Dynamic>): Void {
        final argsList = this.funcCalls.exists(name)
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
        final funcCalls = this.funcCalls.exists(name) ? this.funcCalls.get(name) : null;
        if (funcCalls != null && callIndex >= 0 && callIndex < funcCalls.length) {
            return funcCalls[callIndex];
        } else {
            return null;
        }
    }


    public static function parseJsonFile(filename: String): Dynamic {
        return haxe.Json.parse(sys.io.File.getContent(filename));
    }


    private var funcCalls: StringMap<Array<Array<Dynamic>>>;
}
