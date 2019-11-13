package connect;

import connect.api.QueryParams;
import connect.models.IdModel;
import haxe.Constraints.Function;


#if java
typedef ProcessorStepFunc = connect.native.JavaBiFunction<Processor, String, String>;
#else
@:dox(hide)
typedef ProcessorStepFunc = (Processor, String) -> String;
#end


/**
    The Processor helps automating the task of processing a list of requests, and updates the log
    automatically with all operations performed.

    A Processor splits the processing of requests into different flows. Each `Flow` will process
    the requests that return true for a given filter function that is specified when creating the
    flow. For example, you can create one flow for requests of type "purchase", another for the
    ones of type "cancel", etc.

    Then, each flow consist of a series of steps, where each step is a function that receives as
    arguments the flow itself (so you can subclass `Flow` and add steps as instance methods) and
    the value that was returned from the previous step.

    Once all flows have been defined, you must call the `run` method to process all requests
    of a specific type.

    If an exception is thrown on any step, the rest of the steps will be skipped, and the next
    time the Processor runs, the request will be processed again. If the `Asset` of the request has
    a parameter with the id "__sdk_processor_step" (without quotes), the data about the state of
    the processing will be stored in Connect, and when the request is processed again, it will
    resume from the step that failed, keeping all the data that was processed up until that point.

    You can check the `examples` folder of the SDK to check how to use the Processor in the
    supported target languages.
**/
class Processor extends Base {
    public function new() {
        this.flows = [];
    }


    /**
        Defines a flow of `this` Processor. Steps in the are executed sequentially by the Processor
        when its `run` method is invoked for all the requests that return `true` in the filter
        function passed in the creation of the flow.

        @param flow The flow to add to the processor.
        @returns `this` Processor, so calls to this method can be chained.
    **/
    public function flow(flow: Flow): Processor {
        this.flows.push(flow);
        return this;
    }


    /**
        Runs `this` Processor, executing in sequence all the flows defined for it.

        @param modelClass The class that represents the type of request to be parsed. It must be a
        subclass of `Model` which has a `list` method, like `Request`, `UsageFile` or `TierConfig`.
        @param filters Filters to be used for listing requests.
    **/
    public function run<T>(modelClass: Class<T>, filters: QueryParams): Void {
        // On some targets, a string is received as modelClass, so obtain the real class from it
        switch (Type.typeof(modelClass)) {
            case TClass(String):
                modelClass = untyped Type.resolveClass(cast(modelClass, String));
            default:
        }

        Env.getLogger().openSection('Running Processor on ' + Util.getDate() + ' UTC');

        // List requests
        Env.getLogger().openSection('Listing requests on ' + Util.getDate() + ' UTC');
        var list: Collection<IdModel> = null;
        try {
            var listMethod: Function = Reflect.field(modelClass, 'list');
            list = Reflect.callMethod(modelClass, listMethod, [filters]);
        } catch (ex: Dynamic) {
            Env.getLogger().error('```');
            Env.getLogger().error(Std.string(ex));
            Env.getLogger().error('```');
            Env.getLogger().error('');
            Env.getLogger().closeSection();
            Env.getLogger().closeSection();
            return;
        }
        Env.getLogger().closeSection();
        
        // Call each flow
        for (flow in flows) {
            flow._run(list);
        }

        Env.getLogger().closeSection();
    }

    
    private var flows: Array<Flow>;
}
