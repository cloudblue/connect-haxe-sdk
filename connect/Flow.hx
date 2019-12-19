package connect;

import connect.models.AssetRequest;
import connect.models.IdModel;
import connect.models.Param;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;
import haxe.Constraints.Function;
import haxe.Json;


#if java
typedef FilterFunc = connect.native.JavaFunction<IdModel, Bool>;
typedef StepFunc = connect.native.JavaConsumer<Flow>;
#else
@:dox(hide)
typedef FilterFunc = (IdModel) -> Bool;
@:dox(hide)
typedef StepFunc = (Flow) -> Void;
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
        this.data = new Dictionary();
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
        @param func The function to execute for this step. It receives `this` Flow as argument,
        and it cannot return a value.
        @returns `this` Flow, so calls to this method can be chained.
    **/
    public function step(description: String, func: StepFunc): Flow {
        this.steps.push(new Step(description, func));
        return this;
    }


    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `AssetRequest` type.

        @returns The `AssetRequest` being processed, or `null` if current request is not of
        Fulfillment api.
    **/
    public function getAssetRequest(): AssetRequest {
        try {
            return cast(this.model, AssetRequest);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `TierConfigRequest` type.

        @returns The `TierConfigRequest` being processed, or `null` if current request is not of
        Tier api.
    **/
    public function getTierConfigRequest(): TierConfigRequest {
        try {
            return cast(this.model, TierConfigRequest);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `UsageFile` type.

        @returns The `UsageFile` being processed, or `null` if current request is not of
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
        Changes the status of the request being processed to "approved", sending the id
        of a Template to render on the portal.

        When using the Flow, this method should be used instead of `AssetRequest.approveByTemplate()` or
        `TierConfigRequest.approveByTemplate()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function approveByTemplate(id: String): Void {
        final request = this.getAssetRequestChanges();
        final tcr = this.getTierConfigRequestChanges();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update();
            request.approveByTemplate(id);
            this.abort("");
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update();
            tcr.approveByTemplate(id);
            this.abort("");
        }
    }


    /**
        Changes the status of the request being processed to "approved", rendering a tile on
        the portal with the given Markdown `text`.

        When using the Flow, this method should be used instead of `AssetRequest.approveByTile()` or
        `TierConfigRequest.approveByTile()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function approveByTile(text: String): Void {
        final request = this.getAssetRequestChanges();
        final tcr = this.getTierConfigRequestChanges();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update();
            request.approveByTile(text);
            this.abort("");
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update();
            tcr.approveByTile(text);
            this.abort("");
        }
    }


    /**
        Changes the status of the request being processed to "failed".

        When using the Flow, this method should be used instead of `AssetRequest.fail()` or
        `TierConfigRequest.fail()`, since this takes care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function fail(reason: String): Void {
        final request = this.getAssetRequestChanges();
        final tcr = this.getTierConfigRequestChanges();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update();
            request.fail(reason);
            this.abort("Failing request");
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update();
            tcr.fail(reason);
            this.abort("Failing request");
        }
    }


    /**
        Changes the status of the request being processed to "inquiring".

        When using the Flow, this method should be used instead of `AssetRequest.inquire()` or
        `TierConfigRequest.inquire()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
        
        @param templateId Id of the template to use in the portal, or `null` to not use any. This
        is only used for AssetRequests.
    **/
    public function inquire(templateId: String): Void {
        final request = this.getAssetRequestChanges();
        final tcr = this.getTierConfigRequestChanges();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update();
            request.inquire(templateId);
            this.abort("Inquiring request");
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update();
            tcr.inquire();
            this.abort("Inquiring request");
        }
    }


    /**
        Changes the status of the request being processed to "pending".

        When using the Flow, this method should be used instead of `AssetRequest.pend()` or
        `TierConfigRequest.pend()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function pend(): Void {
        final request = this.getAssetRequestChanges();
        final tcr = this.getTierConfigRequestChanges();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update();
            request.pend();
            this.abort("Pending request");
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update();
            tcr.update();
            this.abort("Pending request");
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


    private static final STEP_PARAM_ID = '__sdk_processor_step';


    private final filterFunc: FilterFunc;
    private var steps: Array<Step>;
    private var model: IdModel;
    private var originalModelStr: String;
    private var data: Dictionary;
    private var abortRequested: Bool;
    private var abortMessage: String;


    private function process(model: IdModel): Void {
        if (this.prepareRequestAndOpenLogSection(model)) {
            if (this.processSetup()) {
                final stepData = this.loadStepDataIfStored();
                final steps = [for (i in stepData.firstIndex...this.steps.length) this.steps[i]];

                // Process all steps
                F.reduce(
                    steps,
                    function(prevResult, step, i, _) {
                        if (prevResult != null) {
                            return processStep(step, stepData.firstIndex + i, prevResult.lastRequestStr, prevResult.lastDataStr);
                        } else {
                            return null;
                        }
                    },
                    {lastRequestStr: '', lastDataStr: '{}'});
            }
            Env.getLogger().closeSection();
        }
    }


    private function processSetup(): Bool {
        Env.getLogger().openSection('Setup');
        try {
            this.setup();
        } catch (ex: Dynamic) {
            final exStr = Std.string(ex);
            Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, exStr, '');
            if (this.getAssetRequest() != null) {
                this.getAssetRequest()._updateConversation('Skipping request because an exception was thrown: $exStr');
            }
            Env.getLogger().closeSection();
            return false;
        }
        Env.getLogger().closeSection();
        return true;
    }


    private function loadStepDataIfStored(): StepData {
        final stepData = StepStorage.load(this.model.id, getStepParam());
        this.data = stepData.data;
        if (stepData.storage != FailedStorage) {
            Env.getLogger().write(Logger.LEVEL_INFO,
                'Resuming request from step ${stepData.firstIndex + 1} with ${stepData.storage}.');
        }
        return stepData;
    }


    private function getStepParam(): Param {
        return (this.getAssetRequest() != null)
            ? this.getAssetRequest().asset.getParamById(STEP_PARAM_ID)
            : null;
    }


    private function processStep(step: Step, index: Int, lastRequestStr: String,
            lastDataStr: String): {lastRequestStr: String, lastDataStr: String} {
        final requestStr = Util.beautifyObject(this.model.toObject(),
            Env.getLogger().getLevel() != Logger.LEVEL_DEBUG);
        final dataStr = Std.string(this.data);
        
        Env.getLogger().openSection(Std.string(index + 1) + '. ' + step.description);
        
        logStepData(Logger.LEVEL_INFO, requestStr, dataStr, lastRequestStr, lastDataStr);

        // Execute step
        try {
            #if java
            step.func.accept(this);
            #else
            step.func(this);
            #end
        } catch (ex: Dynamic) {
            if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                logStepData(Logger.LEVEL_ERROR, requestStr, dataStr, lastRequestStr, lastDataStr);
            }
            final exStr = Std.string(ex);
            Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, exStr, '');
            if (this.getAssetRequest() != null) {
                this.getAssetRequest()._updateConversation('Skipping request because an exception was thrown: $exStr');
            }
            this.abort();
        }

        return this.processAbortAndCloseLogSection(index, requestStr, dataStr);
    }


    private function prepareRequestAndOpenLogSection(model: IdModel): Bool {
        this.model = model;
        this.originalModelStr = model.toString();

        // Set log filename
        if (this.getAssetRequest() != null) {
            Env.getLogger().setFilename('${this.getAssetRequest().asset.id}.md');
        } else if (this.getTierConfigRequest() != null) {
            Env.getLogger().setFilename('${this.getTierConfigRequest().configuration.id}.md');
        } else if (this.getUsageFile() != null) {
            Env.getLogger().setFilename('${this.getUsageFile().id}.md');
        }

        // Open log section
        Env.getLogger().openSection('Processing request "${this.model.id}" on '
            + Util.getDate() + ' UTC');

        // For Fulfillment requests, check if we must skip due to pending migration
        if (this.getAssetRequest() != null && this.getAssetRequest().needsMigration()) {
            Env.getLogger().write(Logger.LEVEL_INFO,
                'Skipping request because it is pending migration.');
            Env.getLogger().closeSection();
            return false;
        } else {
            this.abortRequested = false;
            this.abortMessage = null;
            return true;
        }
    }


    private function processAbortAndCloseLogSection(index: Int, requestStr: String,
            dataStr: String) : {lastRequestStr: String, lastDataStr: String} {
        if (this.abortRequested) {
            if (this.abortMessage == null) {
                final param = (this.getAssetRequest() != null)
                    ? this.getAssetRequest().asset.getParamById(STEP_PARAM_ID)
                    : null;
                
                // Save step data if request supports it
                Env.getLogger().write(Logger.LEVEL_INFO,
                    'Skipping request. Trying to save step data.');
                final saveResult = StepStorage.save(this.model,
                    new StepData(index, this.data, ConnectStorage),
                    param,
                    Reflect.field(model, 'update'));
                switch (saveResult) {
                    case ConnectStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data saved in Connect.');
                    case LocalStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data saved locally.');
                    case FailedStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data could not be saved.');
                }
            } else {
                if (this.abortMessage != '') {
                    Env.getLogger().write(Logger.LEVEL_INFO, this.abortMessage);
                }
            }

            Env.getLogger().closeSection();
            return null;
        } else {
            Env.getLogger().closeSection();
            return {lastRequestStr: requestStr, lastDataStr: dataStr};
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


    private function logStepData(level: Int, request: String, data: String,
            lastRequest: String, lastData: String) {
        Env.getLogger().writeList(level, new Collection<String>()
            .push(getFormattedRequest(request, lastRequest))
            .push(getFormattedData(data, lastData, this.data))
        );
    }


    private static function getFormattedRequest(request: String, lastRequest: String): String {
        if (request != lastRequest) {
            if (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG) {
                final lastRequestObj = Util.isJsonObject(lastRequest)
                    ? Json.parse(lastRequest)
                    : null;
                final requestObj = (Util.isJsonObject(request) && lastRequestObj != null)
                    ? Json.parse(request)
                    : null;
                final diff = (lastRequestObj != null && requestObj != null)
                    ? Util.createObjectDiff(requestObj, lastRequestObj)
                    : null;
                final requestStr = (diff != null)
                    ? Util.beautifyObject(diff, false)
                    : request;
                final requestTitle = (diff != null)
                    ? 'Request (changes):'
                    : 'Request:';
                final fmt = Env.getLogger().getFormatter();
                return '$requestTitle${fmt.formatCodeBlock(requestStr, 'json')}';
            } else {
                return 'Request (id): ${request}';
            }
        } else {
            return 'Request: Same as in previous step.';
        }
    }


    private static function getFormattedData(data: String, lastData: String, dataDict: Dictionary): String {
        if (data != '{}') {
            if (data != lastData) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG) {
                    return 'Data:${getDataTable(dataDict)}';
                } else {
                    final keysStr = [for (key in dataDict.keys()) key].join(', ');
                    return 'Data (keys): $keysStr.';
                }
            } else {
                return 'Data: Same as in previous step.';
            }
        } else {
            return 'Data: Empty.';
        }
    }


    private static function getDataTable(data: Dictionary) {
        final dataKeys = [for (key in data.keys()) key];
        final dataCol = new Collection<Collection<String>>()
            .push(new Collection<String>().push('Key').push('Value'));
        Lambda.iter(dataKeys, function(key) {
            dataCol.push(
                new Collection<String>()
                    .push(key)
                    .push(data.get(key))
            );
        });
        return Env.getLogger().getFormatter().formatTable(dataCol);
    }


    private function getAssetRequestChanges(): AssetRequest {
        if (this.getAssetRequest() != null) {
            final originalModel = Json.parse(this.originalModelStr);
            final diff = Util.createObjectDiff(this.model.toObject(), originalModel);
            return connect.models.Model.parse(AssetRequest, Json.stringify(diff));
        } else {
            return null;
        }
    }


    private function getTierConfigRequestChanges(): TierConfigRequest {
        if (this.getTierConfigRequest() != null) {
            final originalModel = Json.parse(this.originalModelStr);
            final diff = Util.createObjectDiff(this.model.toObject(), originalModel);
            return connect.models.Model.parse(TierConfigRequest, Json.stringify(diff));
        } else {
            return null;
        }
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
