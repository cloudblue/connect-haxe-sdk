package connect.flow;

import connect.models.IdModel;
import connect.util.Dictionary;

@:dox(hide)
interface FlowStoreDelegate {
    function onLoad(request:IdModel, firstStep:Int, data:Dictionary, storageType:String, numAttempts:Int):Void;
    function onFailedLoad(request:IdModel):Void;
    function onConnectSave(request:IdModel):Void;
    function onLocalSave(request:IdModel):Void;
    function onFailedSave(request:IdModel):Void;
}
