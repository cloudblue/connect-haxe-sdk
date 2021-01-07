package connect.flow;

#if cslib
typedef StepFunc = connect.native.CsAction<Flow>;
#elseif javalib
typedef StepFunc = connect.native.JavaConsumer<Flow>;
#else
@:dox(hide)
typedef StepFunc = (Flow) -> Void;
#end
