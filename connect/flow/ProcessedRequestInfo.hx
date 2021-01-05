package connect.flow;

import connect.logger.Logger;
import connect.util.Util;
import connect.util.Dictionary;
import connect.models.IdModel;

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
        return (request != null)
            ? Util.beautifyObject(
                request.toObject(),
                Env.getLogger().isCompact(),
                Env.getLogger().getLevel() != Logger.LEVEL_DEBUG,
                Env.getLogger().isBeautified())
            : '';
    }

    private static function dataToString(data:Null<Dictionary>):String {
        return (data != null)
            ? Std.string(data)
            : '{}';
    }
}
