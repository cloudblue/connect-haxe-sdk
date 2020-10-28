/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

package connect;

import connect.logger.ILoggerFormatter;
import connect.logger.Logger;
import connect.models.AssetRequest;
import connect.models.IdModel;
import connect.models.Listing;
import connect.models.Param;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;
import connect.storage.StepData;
import connect.storage.StepStorage;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import connect.util.Util;
import haxe.Json;

#if cslib
typedef FilterFunc = connect.native.CsFunc<IdModel, Bool>;
typedef StepFunc = connect.native.CsAction<Flow>;
#elseif javalib
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
    public function new(filterFunc:FilterFunc) {
        this.filterFunc = filterFunc;
        this.steps = [];
        this.data = new Dictionary();
        this.stepAttempt = 0;
        this.storeRequestOnFailure = true;
        this.skipRequestOnPendingMigration = true;
    }

    /**
        Enables or disables storing of request data when the Flow fails execution. Defaults to true.
    **/
    public function setStoreRequestOnFailure(enable:Bool):Void {
        this.storeRequestOnFailure = enable;
    }

    /**
        Tells if the flow stores request data when Flow execution fails.
    **/
    public function storesRequestOnFailure():Bool {
        return this.storeRequestOnFailure;
    }

    /**
        Enables or disables skipping the request when it is pending migration. Defaults to true.
    **/
    public function setSkipRequestOnPendingMigration(enable:Bool):Void {
        this.skipRequestOnPendingMigration = enable;
    }

    /**
        Tells if requests are automatically skipped when they are pending migration.
    **/
    public function skipsRequestOnPendingMigration():Bool {
        return this.skipRequestOnPendingMigration;
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
    public function setup():Void {}

    /**
        Defines a step of `this` Flow. Steps are executed sequentially by the Flow
        when its `run` method is invoked.

        @param description Description of what the step does, so the Flow can indicate it
        in the log.
        @param func The function to execute for this step. It receives `this` Flow as argument,
        and it cannot return a value.
        @returns `this` Flow, so calls to this method can be chained.
    **/
    public function step(description:String, func:StepFunc):Flow {
        this.steps.push(new Step(description, func));
        return this;
    }

    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `AssetRequest` type.

        @returns The `AssetRequest` being processed, or `null` if current request is not of
        Fulfillment api.
    **/
    public function getAssetRequest():AssetRequest {
        try {
            return cast(this.model, AssetRequest);
        } catch (ex:Dynamic) {
            return null;
        }
    }

    /**
        This can be called within your steps to get the element being processed, as long as it
        is of the `Listing` type.

        @returns The `Listing` being processed, or `null` if current element is not of
        Listing api.
    **/
    public function getListing():Listing {
        try {
            return cast(this.model, Listing);
        } catch (ex:Dynamic) {
            return null;
        }
    }

    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `TierConfigRequest` type.

        @returns The `TierConfigRequest` being processed, or `null` if current request is not of
        Tier api.
    **/
    public function getTierConfigRequest():TierConfigRequest {
        try {
            return cast(this.model, TierConfigRequest);
        } catch (ex:Dynamic) {
            return null;
        }
    }

    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `UsageFile` type.

        @returns The `UsageFile` being processed, or `null` if current request is not of
        Usage api.
    **/
    public function getUsageFile():UsageFile {
        try {
            return cast(this.model, UsageFile);
        } catch (ex:Dynamic) {
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
    public function setData(key:String, value:Dynamic):Flow {
        this.data.set(key, value);
        return this;
    }

    /**
        Retrieves Flow data previously set with `setData`.
        @param key The name of the key that identifies the data to be obtained.
        @returns The value of the data, or `null` if the key does not exist.
    **/
    public function getData(key:String):Dynamic {
        return this.data.get(key);
    }

    /**
     * @return Collection<String> The keys of all the data stored in the Flow.
     */
    public function getDataKeys():Collection<String> {
        return Collection._fromArray([for (key in this.data.keys()) key]);
    }

    /**
        Changes the status of the request being processed to "approved", sending the id
        of a Template to render on the portal.

        When using the Flow, this method should be used instead of `AssetRequest.approveByTemplate()` or
        `TierConfigRequest.approveByTemplate()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function approveByTemplate(id:String):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update(null);
            request.approveByTemplate(id);
            this.abort('');
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update(null);
            tcr.approveByTemplate(id);
            this.abort('');
        }
    }

    /**
        Changes the status of the request being processed to "approved", rendering a tile on
        the portal with the given Markdown `text`.

        When using the Flow, this method should be used instead of `AssetRequest.approveByTile()` or
        `TierConfigRequest.approveByTile()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function approveByTile(text:String):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update(null);
            request.approveByTile(text);
            this.abort('');
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update(null);
            tcr.approveByTile(text);
            this.abort('');
        }
    }

    /**
        Changes the status of the request being processed to "failed".

        When using the Flow, this method should be used instead of `AssetRequest.fail()` or
        `TierConfigRequest.fail()`, since this takes care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function fail(reason:String):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update(null);
            request.fail(reason);
            this.abort('Failing request');
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update(null);
            tcr.fail(reason);
            this.abort('Failing request');
        }
    }

    /**
        Changes the status of the request being processed to "inquiring".

        When using the Flow, this method should be used instead of `AssetRequest.inquire()` or
        `TierConfigRequest.inquire()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps. Also, this method calls `update`
        on the request before changing its status.

        @param templateId Id of the template to use in the portal, or `null` to not use any. This
        is only used for AssetRequests.
        @param params A collection of parameters to update. If `null` is passed, then the
        parameters that have changed in the request will be updated.
    **/
    public function inquire(templateId:String, params: Collection<Param>):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update(params);
            request.inquire(templateId);
            this.abort('Inquiring request');
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update(params);
            tcr.inquire();
            this.abort('Inquiring request');
        }
    }

    /**
        Changes the status of the request being processed to "pending".

        When using the Flow, this method should be used instead of `AssetRequest.pend()` or
        `TierConfigRequest.pend()`, since this take care of cleaning the stored step
        information, and automatically skips any further steps.
    **/
    public function pend():Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            StepStorage.removeStepData(request.id, getStepParam());
            request.update(null);
            request.pend();
            this.abort('Pending request');
        } else if (tcr != null) {
            StepStorage.removeStepData(tcr.id, getStepParam());
            tcr.update(null);
            tcr.pend();
            this.abort('Pending request');
        }
    }

    @:dox(hide)
    public function _run<T>(list:Collection<T>):Void {
        Env.getLogger().openSection('Running ${this.getClassName()} on ${DateTime.now()}');
        // Filter requests
        final filteredList = (this.filterFunc != null)
            ? Collection._fromArray(list.toArray().filter(
                #if cslib
                (m) -> this.filterFunc.Invoke(cast(m, IdModel))))
                #elseif javalib
                (m) -> this.filterFunc.apply(cast(m, IdModel))))
                #else
                (m) -> this.filterFunc(cast(m, IdModel))))
                #end
            : list;
        // Process each model
        for (model in filteredList) {
            this.process(cast(model, IdModel));
        }
        Env.getLogger().closeSection();
    }

    /**
     * Provide current step attempt
     * @return Int Number of times that this step has been executed
    **/
    public function getCurrentAttempt() {
        return this.stepAttempt;
    }

    private static final SKIP_MSG = 'Skipping request because an exception was thrown: ';
    private static final STEP_PARAM_ID = '__sdk_processor_step';
    private static final STEP_PARAM_ID_TIER = '__sdk_processor_step_tier';
    private static final STEP_PARAM_ID_TIER2 = '__sdk_processor_step_tier2';

    private final filterFunc:FilterFunc;
    private var steps:Array<Step>;
    private var model:IdModel;
    private var originalModelStr:String;
    private var data:Dictionary;
    private var abortRequested:Bool;
    private var abortMessage:String;
    private var stepAttempt:Int;
    private var storeRequestOnFailure:Bool;
    private var skipRequestOnPendingMigration:Bool;

    private function process(model:IdModel):Void {
        if (this.prepareRequestAndOpenLogSection(model)) {
            if (this.processSetup()) {
                final stepData = this.loadStepDataIfStored();
                this.stepAttempt = (stepData.attempt != null) ? stepData.attempt : 0;
                final steps = [for (i in stepData.firstIndex...this.steps.length) this.steps[i]];

                // Process all steps
                Lambda.fold(steps, function(step, prev) {
                    if (prev != null) {
                        return processStep(step, prev.nextIndex, prev.lastRequestStr, prev.lastDataStr);
                    } else {
                        return null;
                    }
                }, {nextIndex: stepData.firstIndex, lastRequestStr: '', lastDataStr: '{}'});
            }
            Env.getLogger().closeSection();
        }
    }

    private function processSetup():Bool {
        Env.getLogger().openSection('Setup');
        try {
            this.setup();
        } catch (ex:Dynamic) {
            final exStr = getExceptionMessage(ex);
            Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, exStr, '');
            if (this.getAssetRequest() != null) {
                this.getAssetRequest()._updateConversation(SKIP_MSG + exStr);
            }
            Env.getLogger().closeSection();
            return false;
        }
        Env.getLogger().closeSection();
        return true;
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

    private function loadStepDataIfStored():StepData {
        if (this.storesRequestOnFailure()) {
            final stepData = StepStorage.load(this.model.id, getStepParam());
            this.data = stepData.data;
            if (stepData.storage != FailedStorage) {
                Env.getLogger().write(Logger.LEVEL_INFO, 'Resuming request from step ${stepData.firstIndex + 1} with ${stepData.storage}.');
            }
            return stepData;
        } else {
            return new StepData(0, {}, FailedStorage, 1);
        }
    }

    private function getStepParam():Param {
        final assetRequest = this.getAssetRequest();
        final tierConfigRequest = this.getTierConfigRequest();
        return
            (assetRequest != null) ? assetRequest.asset.getParamById(STEP_PARAM_ID) :
            (tierConfigRequest != null && tierConfigRequest.tierLevel == 1) ? tierConfigRequest.getParamById(STEP_PARAM_ID_TIER) :
            (tierConfigRequest != null && tierConfigRequest.tierLevel == 2) ? tierConfigRequest.getParamById(STEP_PARAM_ID_TIER2) :
            null;
    }

    private function processStep(step:Step, index:Int, lastRequestStr:String, lastDataStr:String):{nextIndex:Int, lastRequestStr:String, lastDataStr:String} {
        final requestStr = Util.beautifyObject(
            this.model.toObject(),
            Env.getLogger().isCompact(),
            Env.getLogger().getLevel() != Logger.LEVEL_DEBUG,
            Env.getLogger().isBeautified());
        final dataStr = Std.string(this.data);

        Env.getLogger().openSection(Std.string(index + 1) + '. ' + step.description);

        logStepData(Logger.LEVEL_INFO, requestStr, dataStr, lastRequestStr, lastDataStr);

        // Execute step
        try {
            #if cslib
            step.func.Invoke(this);
            #elseif javalib
            step.func.accept(this);
            #else
            step.func(this);
            #end
        } catch (ex:Dynamic) {
            if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                logStepData(Logger.LEVEL_ERROR, requestStr, dataStr, lastRequestStr, lastDataStr);
            }
            final exStr = getExceptionMessage(ex);
            Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, exStr, '');
            if (this.getAssetRequest() != null) {
                this.getAssetRequest()._updateConversation(SKIP_MSG + exStr);
            }
            if (this.getAssetRequest() != null) {
                this.getAssetRequest().update(null);
            } else if (this.getTierConfigRequest() != null) {
                this.getTierConfigRequest().update(null);
            }
            this.abort();
        }

        return this.processAbortAndCloseLogSection(index, requestStr, dataStr);
    }

    private function prepareRequestAndOpenLogSection(model:IdModel):Bool {
        this.model = model;
        this.originalModelStr = model.toString();

        final assetRequest = this.getAssetRequest();
        final listing = this.getListing();
        final tierConfigRequest = this.getTierConfigRequest();
        final usageFile = this.getUsageFile();

        // Get provider
        final provider =
            (assetRequest != null && assetRequest.asset.connection.provider != null) ?
                assetRequest.asset.connection.provider.id :
            (listing != null && listing.provider != null) ?
                listing.provider.id :
            (tierConfigRequest != null && tierConfigRequest.configuration.connection.provider != null) ?
                tierConfigRequest.configuration.connection.provider.id :
            (usageFile != null && usageFile.provider != null) ?
                usageFile.provider.id :
            'provider';

        // Get hub
        final hub =
            (assetRequest != null && assetRequest.asset.connection.hub != null) ?
                assetRequest.asset.connection.hub.id :
            (tierConfigRequest != null && tierConfigRequest.configuration.connection.hub != null) ?
                tierConfigRequest.configuration.connection.hub.id :
            'hub';

        // Get marketplace
        final marketplace =
            (assetRequest != null && assetRequest.marketplace != null) ?
                assetRequest.marketplace.id :
            (listing != null && listing.contract.marketplace != null) ?
                listing.contract.marketplace.id :
            (tierConfigRequest != null && tierConfigRequest.configuration.marketplace != null) ?
                tierConfigRequest.configuration.marketplace.id :
            (usageFile != null && usageFile.marketplace != null) ?
                usageFile.marketplace.id :
            'marketplace';

        // Get product
        final product =
            (assetRequest != null && assetRequest.asset.product != null) ?
                assetRequest.asset.product.id :
            (listing != null && listing.product != null) ?
                listing.product.id :
            (tierConfigRequest != null && tierConfigRequest.configuration.product != null) ?
                tierConfigRequest.configuration.product.id :
            (usageFile != null && usageFile.product != null) ?
                usageFile.product.id :
            'product';
        
        
        // Get tier account
        final tierAccount = 
            (assetRequest != null && assetRequest.asset.tiers.customer != null) ?
                assetRequest.asset.tiers.customer.id:
            (tierConfigRequest != null && tierConfigRequest.configuration.account != null) ?
                tierConfigRequest.configuration.account.id :
            'tier_account';

        // Set log filename
        if (assetRequest != null || tierConfigRequest != null) {
            Env.getLogger().setFilename('$provider/$hub/$marketplace/$product/$tierAccount');
        } else if (listing != null || usageFile != null) {
            Env.getLogger().setFilename('usage/$provider/$marketplace');
        }

        // Open log section
        Env.getLogger().openSection('Processing request "${this.model.id}" on ${DateTime.now()}');

        // For asset requests, check if we must skip due to pending migration
        if (assetRequest != null && assetRequest.needsMigration() && skipsRequestOnPendingMigration() && assetRequest.type == 'purchase') {
            Env.getLogger().write(Logger.LEVEL_INFO, 'Skipping request because it is pending migration.');
            Env.getLogger().closeSection();
            return false;
        } else {
            this.abortRequested = false;
            this.abortMessage = null;
            return true;
        }
    }

    private function processAbortAndCloseLogSection(index:Int, requestStr:String, dataStr:String):{nextIndex:Int, lastRequestStr:String, lastDataStr:String} {
        if (this.abortRequested) {
            if (this.abortMessage == null) {
                // Save step data if request supports it
                Env.getLogger().write(Logger.LEVEL_INFO, 'Skipping request. Trying to save step data.');
                final saveResult = this.storesRequestOnFailure()
                    ? StepStorage.save(
                        this.model,
                        new StepData(index, this.data, ConnectStorage, this.stepAttempt + 1),
                        this.getStepParam(),
                        Reflect.field(model, 'update'))
                    : OmittedStorage;
                switch (saveResult) {
                    case ConnectStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data saved in Connect.');
                    case LocalStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data saved locally.');
                    case FailedStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data could not be saved.');
                    case OmittedStorage:
                        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data will not be saved because feature is disabled.');
                }
            } else {
                if (this.abortMessage != '') {
                    Env.getLogger().write(Logger.LEVEL_INFO, this.abortMessage);
                }
            }

            Env.getLogger().closeSection();
            return null;
        } else {
            this.stepAttempt = 1;
            Env.getLogger().closeSection();
            return {nextIndex: index + 1, lastRequestStr: requestStr, lastDataStr: dataStr};
        }
    }

    /**
        Without a message, a skip is performed with the standard skip message, which
        will try to store step data. If a message is provided, no data is stored, and that message
        is printed instead as long as it is not an empty string.
    **/
    private function abort(?message:String):Void {
        this.abortRequested = true;
        this.abortMessage = message;
    }

    private function logStepData(level:Int, request:String, data:String, lastRequest:String, lastData:String) {
        for (handler in Env.getLogger().getHandlers()) {
            final list = new Collection<String>().push(getFormattedRequest(request, lastRequest, handler.formatter))
                .push(getFormattedData(data, lastData, this.data, handler.formatter));
            Env.getLogger()._writeToHandler(level, handler.formatter.formatList(level,list), handler);
        }
    }

    private static function getFormattedRequest(request:String, lastRequest:String, fmt:ILoggerFormatter):String {
        if (request != lastRequest) {
            if (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG) {
                final lastRequestObj = Util.isJsonObject(lastRequest) ? Json.parse(lastRequest) : null;
                final requestObj = (Util.isJsonObject(request) && lastRequestObj != null) ? Json.parse(request) : null;
                final diff = (lastRequestObj != null && requestObj != null) ? Util.createObjectDiff(requestObj, lastRequestObj) : null;
                final requestStr = (diff != null)
                    ? Util.beautifyObject(
                        diff,
                        Env.getLogger().isCompact(),
                        false,
                        Env.getLogger().isBeautified())
                    : request;
                final requestTitle = (diff != null) ? 'Request (changes):' : 'Request:';
                return '$requestTitle${fmt.formatCodeBlock(Env.getLogger().getLevel(),Std.string(requestStr), 'json')}';
            } else {
                return 'Request (id): ${request}';
            }
        } else {
            return 'Request: Same as in previous step.';
        }
    }

    private static function getFormattedData(data:String, lastData:String, dataDict:Dictionary, fmt:ILoggerFormatter):String {
        if (data != '{}') {
            if (data != lastData) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG) {
                    return 'Data:${getDataTable(dataDict, fmt)}';
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

    private static function getDataTable(data:Dictionary, fmt:ILoggerFormatter):String {
        final dataKeys = [for (key in data.keys()) key];
        final dataCol = new Collection<Collection<String>>().push(new Collection<String>().push('Key').push('Value'));
        Lambda.iter(dataKeys, function(key) {
            dataCol.push(new Collection<String>().push(key).push(data.get(key)));
        });
        return fmt.formatTable(Env.getLogger().getLevel(),dataCol);
    }
    
    private function getClassName():String {
        #if js
        final constructorName = js.Syntax.code("{0}.constructor.name", this);
        final className = (constructorName != 'Object') ? constructorName : Type.getClassName(Type.getClass(this));
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
    public final description:String;
    public final func:StepFunc;

    public function new(description:String, func:StepFunc) {
        this.description = description;
        this.func = func;
    }
}
