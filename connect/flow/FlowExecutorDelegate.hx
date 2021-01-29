package connect.flow;

import connect.models.IdModel;

@:dox(hide)
interface FlowExecutorDelegate {
    function onStepBegin(request:IdModel, step:Step, index:Int):Void;
    function onStepEnd(request:IdModel, step:Step, index:Int):Void;
    function onStepFail(request:IdModel, step:Step, index:Int, msg:String):Void;
    function onStepSkip(request:IdModel, step:Step, index:Int):Void;
    function onStepAbort(request:IdModel, step:Step, index:Int, msg:String):Void;
}
