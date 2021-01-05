package connect.flow;

import haxe.macro.Compiler.NullSafetyMode;
import connect.models.IdModel;
import connect.util.Dictionary;
import connect.util.Util;

@:dox(hide)
class FlowExecutor {
    private final flow:Flow;
    private final observer:Null<FlowExecutorObserver>;
    private final steps:Array<Step>;
    private var abortRequested:Bool;
    private var abortMessage:Null<String>;

    public function new(flow:Flow, observer:Null<FlowExecutorObserver>) {
        this.flow = flow;
        this.observer = observer;
        this.steps = [];
        this.abortRequested = false;
        this.abortMessage = null;
    }

    public function addStep(description:String, func:StepFunc):Void {
        this.steps.push(new Step(description, func));
    }

    public function executeRequest(request:IdModel, data:Dictionary, firstIndex: Int):Void {
        final steps = [for (i in firstIndex...this.steps.length) this.steps[i]];
        this.processSteps(request, steps, data, firstIndex);
    }

    private function processSteps(request:IdModel, steps:Array<Step>, data:Dictionary, firstIndex:Int):Void {
        Lambda.foldi(steps, function(step, shouldContinue, index) {
            if (shouldContinue) {
                return processStep(request, step, data, index + firstIndex);
            } else {
                return false;
            }
        }, true);
    }

    private function processStep(request:IdModel, step:Step, data:Dictionary, index:Int):Bool {
        if (this.observer != null) {
            this.observer.onStepBegin(request, step, index);
        }
        this.callStepFunc(request, step, index);
        return this.processAbortOrEnd(request, step, index);
    }

    private function callStepFunc(request:IdModel, step:Step, index:Int):Void {
        try {
            #if cslib
            step.getFunc().Invoke(this.flow);
            #elseif javalib
            step.getFunc().accept(this.flow);
            #else
            step.getFunc()(this.flow);
            #end
        } catch (ex:Dynamic) {
            if (this.observer != null) {
                this.observer.onStepFail(request, step, index, getExceptionMessage(ex));
            }
            this.abort();
        }
    }

    private static function getExceptionMessage(ex: Dynamic): String {
    #if php
        try {
            return ex.getMessage();
        } catch (_: Dynamic) {
            return Std.string(ex);
        }
    #elseif python
        return python.Syntax.code("str({0})", ex);
    #else
        return Std.string(ex);
    #end
    }

    private function processAbortOrEnd(request:IdModel, step:Step, index:Int):Bool {
        if (this.abortRequested) {
            if (this.observer != null) {
                if (this.abortMessage == null) {
                    this.observer.onStepSkip(request, step, index);
                } else {
                    this.observer.onStepAbort(request, step, index, this.abortMessage);
                }
            }
            this.abortRequested = false;
            return false;
        } else {
            if (this.observer != null) {
                this.observer.onStepEnd(request, step, index);
            }
            return true;
        }
    }

    /**
        Without a message, a skip is performed with the standard skip message, which
        will try to store step data. If a message is provided, no data is stored, and that message
        is printed instead as long as it is not an empty string.
    **/
    public function abort(?message:String):Void {
        this.abortRequested = true;
        this.abortMessage = message;
    }
}
