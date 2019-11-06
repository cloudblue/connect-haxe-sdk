package connect;

import haxe.Json;
import connect.api.QueryParams;
import connect.models.IdModel;
import connect.models.Request;
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

    A Processor splits the processing of a request into a series of steps, where each step is a
    function that receives as arguments the processor itself (so you can subclass Processor and
    add steps as instance methods) and the value that was returned from the previous step.

    Once all steps have been defined, you must call the `run` method to process all requests
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
        this.steps = [];
    }


    /**
        Defines a step of `this` Processor. Steps are executed sequentially by the Processor
        when its `run` method is invoked.

        @param description Description of what the step does, so the Processor can indicate it
        in the log 
        @param func The function to execute for this step. It can return a value that will be
        passed to the next step, and the function receives two arguments: The first one is the
        Processor itself (so you can subclass Processor and add steps as instance methods), and
        the second one is the value returned from the previous step.
        @returns `this` Processor, so calls to this method can be chained.
    **/
    public function step(description: String, func: ProcessorStepFunc): Processor {
        this.steps.push(new Step(description, func));
        return this;
    }


    /**
        Runs `this` Processor, executing in sequence all the steps defined for it.

        @param modelClass The class that represents the type of request to be parsed. It must be a
        subclass of `Model` which has a `list` method, like `Request` or `TierConfig`.
        @param filters Filters to be used for listing requests.
    **/
    public function run<T>(modelClass: Class<T>, filters: QueryParams): Void {
        // On some targets, a string is received as modelClass, so obtain the real class from it
        switch (Type.typeof(modelClass)) {
            case TClass(String):
                modelClass = untyped Type.resolveClass(cast(modelClass, String));
            default:
        }

        Env.getLogger().openSection('Running ${this.getClassName()} on ' + getDate());

        // List requests
        Env.getLogger().openSection('Listing requests on ' + getDate());
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
        
        // Process each request
        for (model in list) {
            this.processRequest(model);
        }
        Env.getLogger().closeSection();
    }

    
    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `Request` type.

        @returns The Fulfillment `Request` being processed, or `null` if current request is not of
        Fulfillment api.
    **/
    public function getRequest(): Request {
        try {
            return cast(this.model, Request);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Steps can pass data to the next one using the return value, but this data could be lost if
        we need to access it several steps later. For this reason, every Processor has a dictionary
        of keys and values to store custom data, that can be set with this method and retreived
        later on with `getData`. It is VERY important for the correct function of the Processor
        to only rely on the data set using this mechanism, and NEVER add additional properties
        when creating a subclass of Processor, since this data would not be automatically saved
        to support resuming in case processing fails.

        @param key The name of the key that will be used to identify this data.
        @param value The value to store. It is recommended to use primitive types, strings,
        instances of `Model`, or other classes that implement a `toString` method so they
        can be serialized.
        @returns `this` Processor, so calls to this method can be chained.
    **/
    public function setData(key: String, value: Dynamic): Processor {
        this.data.set(key, value);
        return this;
    }
    
    
    /**
        Retrieves Processor data previously set with `setData`.
        @param key The name of the key that identifies the data to be obtained.
        @returns The value of the data, or `null` if the key does not exist.
    **/
    public function getData(key: String): Dynamic {
        return this.data.get(key);
    }


    /**
        Changes the status of the Request being processed to "approved", sending the id
        of a Template to render on the portal.

        When using the Processor, this method should be used instead of
        `Request.approveByTemplate()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function approveByTemplate(id: String): Request {
        final request = this.getRequest();
        if (request != null) {
            removeStepData(request);
            request.update();
            final result = request.approveByTemplate(id);
            this.abort("");
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "approved", rendering a tile on
        the portal with the given Markdown `text`.

        When using the Processor, this method should be used instead of `Request.approveByTile()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function approveByTile(text: String): Request {
        final request = this.getRequest();
        if (request != null) {
            removeStepData(request);
            request.update();
            final result = request.approveByTile(text);
            this.abort("");
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "failed".

        When using the Processor, this method should be used instead of `Request.fail()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): Request {
        var request = this.getRequest();
        if (request != null) {
            removeStepData(request);
            request.update();
            var result = request.fail(reason);
            this.abort("Failing request");
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "inquiring".

        When using the Processor, this method should be used instead of `Request.inquire()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function inquire(): Request {
        var request = this.getRequest();
        if (request != null) {
            removeStepData(request);
            request.update();
            var result = request.inquire();
            this.abort("Inquiring request");
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "pending".

        When using the Processor, this method should be used instead of `Request.pend()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function pend(): Request {
        var request = this.getRequest();
        if (request != null) {
            var param = request.asset.getParamById(STEP_PARAM_ID);
            if (param != null) {
                param.value = '';
            }
            request.update();
            var result = request.pend();
            this.abort("Pending request");
            return result;
        } else {
            return null;
        }
    }
    

    private static inline var STEP_PARAM_ID = '__sdk_processor_step';
    
    private var steps: Array<Step>;
    private var model: IdModel;
    private var data: Dictionary;
    private var abortRequested: Bool;
    private var abortMessage: String;


    private function processRequest(model: IdModel): Void {
        if (this.prepareAndOpenLogSection(model)) {
            // If there is stored step data, set data and jump to that step
            final stepParam = (this.getRequest() != null)
                ? this.getRequest().asset.getParamById(STEP_PARAM_ID)
                : null;
            final stepData = StepStorage.load(this.model.id, stepParam);
            var input = stepData.input;
            this.data = stepData.data;
            if (stepData.firstIndex != 0) {
                Env.getLogger().info('Resuming request from step ${stepData.firstIndex + 1}.');
            }

            // Process each step
            var lastRequestStr = '';
            var lastDataStr = '{}';
            for (index in stepData.firstIndex...this.steps.length) {
                final step = this.steps[index];
                final requestStr = Inflection.beautify(this.model.toString(),
                    Env.getLogger().getLevel() != Logger.LEVEL_DEBUG);
                final dataStr = Std.string(this.data);
                
                Env.getLogger().openSection(Std.string(index + 1) + '. ' + step.description);
                
                this.logStepData(Env.getLogger().info, Inflection.beautify(input, false),
                    requestStr, dataStr, lastRequestStr, lastDataStr);

                // Execute step
                try {
                    #if java
                    input = step.func.apply(this, input);
                    #else
                    input = step.func(this, input);
                    #end
                } catch (ex: Dynamic) {
                    if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                        this.logStepData(Env.getLogger().error, Inflection.beautify(input, false),
                            requestStr, dataStr, lastRequestStr, lastDataStr);
                    }
                    final exStr = Std.string(ex);
                    Env.getLogger().error('```');
                    Env.getLogger().error(exStr);
                    Env.getLogger().error('```');
                    Env.getLogger().error('');
                    if (this.getRequest() != null) {
                        this.getRequest()._updateConversation('Skipping request because an exception was thrown: $exStr');
                    }
                    this.abort();
                }

                if (this.abortRequested) {
                    if (this.abortMessage == null) {
                        final param = (this.getRequest() != null)
                            ? this.getRequest().asset.getParamById(STEP_PARAM_ID)
                            : null;
                        
                        // Save step data if request supports it
                        Env.getLogger().info('Skipping request. Trying to save step data.');
                        final saveResult = StepStorage.save(this.model,
                            new StepData(index, input, this.data),
                            param,
                            Reflect.field(model, 'update'));
                        switch (saveResult) {
                            case StoreConnect:
                                Env.getLogger().info('Step data saved in Connect.');
                            case StoreLocal:
                                Env.getLogger().info('Step data saved locally.');
                            case StoreFail:
                                Env.getLogger().info('Step data could not be saved.');
                        }
                    } else {
                        if (this.abortMessage != '') {
                            Env.getLogger().info(this.abortMessage);
                        }
                    }

                    Env.getLogger().closeSection();
                    break;
                } else {
                    lastRequestStr = requestStr;
                    lastDataStr = dataStr;
                    Env.getLogger().closeSection();
                }
            }

            Env.getLogger().closeSection();
        }
    }


    private function prepareAndOpenLogSection(model: IdModel): Bool {
        this.model = model;

        // Open log section
        if (this.getRequest() != null) {
            Env.getLogger().openSection('Processing request "' + this.model.id
                + '" for asset "' + this.getRequest().asset.id
                + '" on ' + getDate());
        } else {
            Env.getLogger().openSection('Processing request "${this.model.id}" on '
                + getDate());
        }

        // For Fulfillment requests, check if we must skip due to pending migration
        if (this.getRequest() != null && this.getRequest().needsMigration()) {
            Env.getLogger().info('Skipping request because it is pending migration.');
            Env.getLogger().closeSection();
            return false;
        } else {
            this.abortRequested = false;
            this.abortMessage = null;
            return true;
        }
    }


    /**
        Without a message, a skip is performed with the standard skip message, which
        will try to store step data. If a message is provided, no data is stored, and that message
        is printed instead as long as it is not an empty string.
    **/
    private function abort(?message: String): Void {
        this.abortRequested = true;
        this.abortMessage = message;
    }


    private static function removeStepData(request: Request): Void {
        final param = request.asset.getParamById(STEP_PARAM_ID);
        if (param != null && param.value != null && Inflection.isJsonObject(param.value)) {
            final storeData = Json.parse(param.value);
            if (Reflect.hasField(storeData, request.id)) {
                Reflect.deleteField(storeData, request.id);
            }
            param.value = Json.stringify(storeData);
        }
    }


    private static function getDate(): String {
        var date = Date.now();
        return new Date(
            date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(),
            date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()
        ).toString() + ' UTC';
    }


    private function logStepData(func: Function, input: String, request: String, data: String,
            lastRequest: String, lastData: String) {
        // Log input
        if (input != null && Inflection.isJson(input)) {
            Reflect.callMethod(Env.getLogger(), func, ['* Input: ']);
            Reflect.callMethod(Env.getLogger(), func, ['```json']);
            Reflect.callMethod(Env.getLogger(), func, [input]);
            Reflect.callMethod(Env.getLogger(), func, ['```']);
        } else {
            Reflect.callMethod(Env.getLogger(), func, ['* Input: ${input}']);
        }

        // Log request
        if (request != lastRequest) {
            if (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG) {
                Reflect.callMethod(Env.getLogger(), func, ['* Request:']);
                Reflect.callMethod(Env.getLogger(), func, ['```json']);
                Reflect.callMethod(Env.getLogger(), func, [request]);
                Reflect.callMethod(Env.getLogger(), func, ['```']);
            } else {
                Reflect.callMethod(Env.getLogger(), func, ['* Request (id): ${request}']);
            }
        } else {
            Reflect.callMethod(Env.getLogger(), func, ['* Request: (Same as previous step).']);
        }

        // Log data
        if (data != '{}') {
            if (data != lastData) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG) {
                    var keys = this.data.keys();
                    Reflect.callMethod(Env.getLogger(), func, ['* Data:']);
                    Reflect.callMethod(Env.getLogger(), func, ['| Key | Value |']);
                    Reflect.callMethod(Env.getLogger(), func, ['| --- | ----- |']);
                    for (key in keys) {
                        var val = Std.string(this.getData(key));
                        Reflect.callMethod(Env.getLogger(), func, ['| ${key} | ${val} |']);
                    }
                } else {
                    var keys = this.data.keys();
                    var keysStr = [for (key in keys) key].join(', ');
                    Reflect.callMethod(Env.getLogger(), func, ['* Data (keys): ${keysStr}.']);
                }
            } else {
                Reflect.callMethod(Env.getLogger(), func, ['* Data: (Same as previous step).']);
            }
        } else {
            Reflect.callMethod(Env.getLogger(), func, ['* Data: (Empty).']);
        }

        Reflect.callMethod(Env.getLogger(), func, ['']);
    }


    private function getClassName(): String {
    #if js
        final constructorName = js.Syntax.code("{0}.constructor.name", this);
        final className = (constructorName != 'Object')
            ? constructorName
            : Type.getClassName(Type.getClass(this));
        return className;
    #elseif php
        return php.Syntax.code("get_class({0})", this);
    #elseif python
        return python.Syntax.code("type({0}).__name__", this);
    #else
        return Type.getClassName(Type.getClass(this));
    #end
    }
}


private class Step {
    public var description: String;
    public var func: ProcessorStepFunc;

    public function new(description: String, func: ProcessorStepFunc) {
        this.description = description;
        this.func = func;
    }
}
