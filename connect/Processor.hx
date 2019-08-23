package connect;

typedef FilterMap = Map<String, String>;

class Processor {
    public var listPath(default, null) : String;
    public var defaultFilters(default, null) : FilterMap;

    public function new(listPath:String, defaultFilters:FilterMap) {
        this.listPath = listPath;
        this.defaultFilters = defaultFilters;
    }
    
    public function list() : Array<Dynamic> {
        var response = Config.getInstance().syncRequest("GET", listPath, this.defaultFilters);
        if (response.status == 200) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
    }

    public function process() : Void {
        var list = this.list();
        for (request in list) {
            try {
                var activation = this.onProcessRequest(request);
            }
        }
    }

    public dynamic function onProcessRequest(request:Dynamic) : Activation {
        throw "onProcessRequest method must be assigned";
    }
}
