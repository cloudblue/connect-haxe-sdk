package connect;

import connect.api.QueryParams;
import connect.models.IdModel;
import connect.models.Request;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;
import haxe.Constraints.Function;


/**
    The Processor helps automating the task of processing a list of requests, and updates the log
    automatically with all operations performed.

    A Processor splits the processing of requests into different flows. Each `Flow` will process
    the requests that return true for a given filter function that is specified when creating the
    flow. For example, you can create one flow for requests of type "purchase", another for the
    ones of type "cancel", etc.

    Then, each flow consist of a series of steps, where each step is a function that receives
    the flow itself as argument (so you can subclass `Flow` and add steps as instance methods).

    Once all flows have been defined, you must call the `Processor.processRequests`,
    `Processor.processUsageFiles`, or `Processor.processTierConfigRequests` method to process
    requests, depending on the type you want to process.

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
        Processes all fullfilment `UsageFile` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `Request.list` method.
    **/
    public function processRequests(filters: QueryParams): Void {
        run(Request, filters);
    }


    /**
        Processes all `TierConfigRequest` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `TierConfigRequest.list` method.
    **/
    public function processTierConfigRequests(filters: QueryParams): Void {
        run(TierConfigRequest, filters);
    }


    /**
        Processes all `UsageFile` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `UsageFile.list` method.
    **/
    public function processUsageFiles(filters: QueryParams): Void {
        run(UsageFile, filters);
    }


    private var flows: Array<Flow>;


    private function run<T>(modelClass: Class<T>, filters: QueryParams): Void {
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
            final listMethod: Function = Reflect.field(modelClass, 'list');
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
}
