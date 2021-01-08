/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;

import connect.api.Query;
import connect.logger.Logger;
import connect.models.AssetRequest;
import connect.models.Listing;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;
import connect.util.DateTime;
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
    private var flows: Array<Flow>;
    
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
        Processes all `AssetRequest` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `AssetRequest.list` method.
    **/
    public function processAssetRequests(filters: Query): Void {
        run(AssetRequest, filters);
    }

    /**
        Processes all `Listing` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `Listing.list` method.
    **/
    public function processListings(filters: Query): Void {
        run(Listing, filters);
    }

    /**
        Processes all `TierConfigRequest` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `TierConfigRequest.list` method.
    **/
    public function processTierConfigRequests(filters: Query): Void {
        run(TierConfigRequest, filters);
    }

    /**
        Processes all `UsageFile` objects that match the given filters,
        executing in sequence all the flows defined for them.

        @param filters Filters to be used for listing requests. It can contain
        any of the filters specified for the `UsageFile.list` method.
    **/
    public function processUsageFiles(filters: Query): Void {
        run(UsageFile, filters);
    }

    private function run<T>(modelClass: Class<T>, filters: Query): Void {
        // On some platforms, a string is received as modelClass, so obtain the real class from it
        switch (Type.typeof(modelClass)) {
            case TClass(String):
                modelClass = untyped Type.resolveClass(cast(modelClass, String));
            default:
        }

        final prevLogName = Env.getLogger().getFilename();
        Env.getLogger().setFilename(null);
        Env.getLogger().openSection('Running Processor on ${DateTime.now()}');

        try {
            // List requests
            Env.getLogger().openSection('Listing requests on ${DateTime.now()}');
            final listMethod: Function = Reflect.field(modelClass, 'list');
            final list = Reflect.callMethod(modelClass, listMethod, [filters]);
            Env.getLogger().closeSection();
            
            // Call each flow
            for (flow in flows) {
                flow._run(list);
            }
        } catch (ex: Dynamic) {
            // Catch exception when listing
            Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, Std.string(ex), '');
            Env.getLogger().closeSection();
        }

        Env.getLogger().closeSection();
        Env.getLogger().setFilename(prevLogName);
    }
}
