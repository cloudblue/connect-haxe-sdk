package connect;

import connect.models.IdModel;
import connect.models.Request;
import connect.models.UsageFile;
import haxe.Constraints.Function;
import haxe.Json;


#if java
typedef FilterFunc = connect.native.JavaFunction<IdModel, Bool>;
typedef StepFunc = connect.native.JavaBiFunction<Flow, java.lang.Object, java.lang.Object>;
#else
@:dox(hide)
typedef FilterFunc = (IdModel) -> Bool;
@:dox(hide)
typedef StepFunc = (Flow, Dynamic) -> Dynamic;
#end


/**
    A Flow represents a set of steps within a `Processor` which are executed for all requests
    that return `true` for a given function. If `null` is passed, all requests will be processed.
**/
class Flow extends Base {
    /**
        Creates a new Flow.

        @param filterFunc A function which is executed for every request listed by the `Processor`
        to which `this` Flow is attached. All requests for which the function returns `true` will
        be processed by `this` Flow when the Processor runs.
    **/
    public function new(filterFunc: FilterFunc) {
        this.filterFunc = filterFunc;
        this.steps = [];
    }


    /**
        The setup function is always called before executing the steps, independently of what is
        the first step that will be run. If you need some initialization tasks that you always
        need to perform independently of whether you are resuming from a previous execution
        or not, you can override this method and write your initialization tasks.

        If you are resuming from a previous execution and this method writes information with
        `Flow.setData`, that information will be overridden with the one restored from the
        previous execution.
    **/
    public function setup(): Void {}


    /**
        Defines a step of `this` Flow. Steps are executed sequentially by the Flow
        when its `run` method is invoked.

        @param description Description of what the step does, so the Flow can indicate it
        in the log.
        @param func The function to execute for this step. It can return a value that will be
        passed to the next step, and the function receives two arguments: The first one is `this`
        Flow, and the second one is the value returned from the previous step.
        @returns `this` Flow, so calls to this method can be chained.
    **/
    public function step(description: String, func: StepFunc): Flow {
        this.steps.push(new Step(description, func));
        return this;
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
        This can be called within your steps to get the request being processed, as long as it
        is of the `UsageFile` type.

        @returns The `USageFile` being processed, or `null` if current request is not of
        Usage api.
    **/
    public function getUsageFile(): UsageFile {
        try {
            return cast(this.model, UsageFile);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Steps can pass data to the next one using the return value, but this data could be lost if
        we need to access it several steps later. For this reason, every Flow has a dictionary
        of keys and values to store custom data, that can be set with this method and retreived
        later on with `getData`. It is VERY important for the correct function of the Flow
        to only rely on the data set using this mechanism, and NEVER add additional properties
        when creating a subclass of Flow, since this data would not be automatically saved
        to support resuming in case processing fails.

        @param key The name of the key that will be used to identify this data.
        @param value The value to store. It is recommended to use primitive types, strings,
        instances of `Model`, or other classes that implement a `toString` method so they
        can be serialized.
        @returns `this` Flow, so calls to this method can be chained.
    **/
    public function setData(key: String, value: Dynamic): Flow {
        this.data.set(key, value);
        return this;
    }
    
    
    /**
        Retrieves Flow data previously set with `setData`.
        @param key The name of the key that identifies the data to be obtained.
        @returns The value of the data, or `null` if the key does not exist.
    **/
    public function getData(key: String): Dynamic {
        return this.data.get(key);
    }


    /**
        Changes the status of the Request being processed to "approved", sending the id
        of a Template to render on the portal.

        When using the Flow, this method should be used instead of `Request.approveByTemplate()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

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

        When using the Flow, this method should be used instead of `Request.approveByTile()`,
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

        When using the Flow, this method should be used instead of `Request.fail()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): Request {
        final request = this.getRequest();
        if (request != null) {
            removeStepData(request);
            request.update();
            final result = request.fail(reason);
            this.abort("Failing request");
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "inquiring".

        When using the Flow, this method should be used instead of `Request.inquire()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function inquire(): Request {
        final request = this.getRequest();
        if (request != null) {
            removeStepData(request);
            request.update();
            final result = request.inquire();
            this.abort("Inquiring request");
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "pending".

        When using the Flow, this method should be used instead of `Request.pend()`,
        since this take care of cleaning the stored step information, and automatically skips any
        further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function pend(): Request {
        final request = this.getRequest();
        if (request != null) {
            final param = request.asset.getParamById(STEP_PARAM_ID);
            if (param != null) {
                param.value = '';
            }
            request.update();
            final result = request.pend();
            this.abort("Pending request");
            return result;
        } else {
            return null;
        }
    }


    @:dox(hide)
    public function _run<T>(list: Collection<T>): Void {
        Env.getLogger().openSection(
            'Running ${this.getClassName()} on ' + Util.getDate() + ' UTC');

        // Filter requests
        final filteredList = (filterFunc != null)
            ? Collection._fromArray(list.toArray().filter(
            #if java
                (m) -> filterFunc.apply(cast(m, IdModel))
            #else
                (m) -> filterFunc(cast(m, IdModel))
            #end
                ))
            : list;
        
        // Process each model
        for (model in filteredList) {
            this.process(cast(model, IdModel));
        }

        Env.getLogger().closeSection();
    }


    private static inline var STEP_PARAM_ID = '__sdk_processor_step';


    private final filterFunc: FilterFunc;
    private var steps: Array<Step>;
    private var model: IdModel;
    private var data: Dictionary;
    private var abortRequested: Bool;
    private var abortMessage: String;


    private function process(model: IdModel): Void {
        if (this.prepareAndOpenLogSection(model)) {
            // Run setup function
            Env.getLogger().openSection('Setup');
            this.setup();
            Env.getLogger().closeSection();

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
                
                this.logStepData(Env.getLogger().info,
                    Inflection.beautify(Std.string(input), false),
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
                        this.logStepData(Env.getLogger().error,
                            Inflection.beautify(Std.string(input), false),
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
                + '" on ' + Util.getDate() + ' UTC');
        } else {
            Env.getLogger().openSection('Processing request "${this.model.id}" on '
                + Util.getDate() + ' UTC');
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
                    final keys = this.data.keys();
                    Reflect.callMethod(Env.getLogger(), func, ['* Data:']);
                    Reflect.callMethod(Env.getLogger(), func, ['| Key | Value |']);
                    Reflect.callMethod(Env.getLogger(), func, ['| --- | ----- |']);
                    for (key in keys) {
                        final val = Std.string(this.getData(key));
                        Reflect.callMethod(Env.getLogger(), func, ['| ${key} | ${val} |']);
                    }
                } else {
                    final keys = this.data.keys();
                    final keysStr = [for (key in keys) key].join(', ');
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
    public final description: String;
    public final func: StepFunc;

    public function new(description: String, func: StepFunc) {
        this.description = description;
        this.func = func;
    }
}
