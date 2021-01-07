package connect.flow;

@:dox(hide)
class Step {
    private final description:String;
    private final func:StepFunc;

    public function new(description:String, func:StepFunc) {
        this.description = description;
        this.func = func;
    }

    public function getDescription():String {
        return this.description;
    }

    public function getFunc():StepFunc {
        return this.func;
    }
}
