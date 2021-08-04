package connect.flow;

import connect.logger.Logger;
import connect.models.IdModel;
import connect.util.Dictionary;
import connect.util.Masker;

@:dox(hide)
class ProcessedRequestInfo {
    private final request:Null<IdModel>;
    private final data:Null<Dictionary>;
    private final requestStr:String;
    private final dataStr:String;

    public function new(request:Null<IdModel>, data:Null<Dictionary>) {
        this.request = request;
        this.data = data;
        this.requestStr = requestToString(request);
        this.dataStr = dataToString(data);
    }

    public function getRequest():Null<IdModel> {
        return this.request;
    }

    public function getData():Null<Dictionary> {
        return this.data;
    }

    public function getRequestString():String {
        return this.requestStr;
    }

    public function getDataString():String {
        return this.dataStr;
    }

    private static function requestToString(request:Null<IdModel>):String {
        if (request != null) {
            return (Env.getLogger().getLevel() != Logger.LEVEL_DEBUG)
                ? Masker.maskObject(request.toObject())
                : haxe.Json.stringify(request.toObject());
        } else {
            return '';
        }
    }

    private static function dataToString(data:Null<Dictionary>):String {
        return (data != null)
            ? Std.string(data)
            : '{}';
    }
}
