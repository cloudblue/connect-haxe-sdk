/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

package connect;

import connect.flow.FlowStoreDelegate;
import connect.flow.FlowStore;
import connect.flow.ProcessedRequestInfo;
import connect.flow.Step;
import connect.flow.FlowExecutor;
import connect.flow.FlowExecutorDelegate;
import connect.flow.FlowLogger;
import connect.flow.RequestCaster;
import connect.flow.StepFunc;
import connect.models.AssetRequest;
import connect.models.IdModel;
import connect.models.Listing;
import connect.models.Param;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;
import connect.util.Collection;
import connect.util.Dictionary;

#if cslib
typedef FilterFunc = connect.native.CsFunc<IdModel, Bool>;
#elseif javalib
typedef FilterFunc = connect.native.JavaFunction<IdModel, Bool>;
#else
@:dox(hide)
typedef FilterFunc = (IdModel) -> Bool;
#end

/**
    A Flow represents a set of steps within a `Processor` which are executed for all requests
    that return `true` for a given function. If `null` is passed, all requests will be processed.
**/
class Flow extends Base implements FlowExecutorDelegate implements FlowStoreDelegate {
    private static final SKIP_MSG = 'Skipping request because an exception was thrown: ';

    private final filterFunc:FilterFunc;
    private var skipRequestOnPendingMigration:Bool;
    private final executor:FlowExecutor;
    private final logger:FlowLogger;
    private final store:FlowStore;
    private var request:IdModel;
    private var data:Dictionary;
    private var volatileData:Dictionary;
    private var firstStep:Int;
    private var lastRequestState:ProcessedRequestInfo;
    private var stepAttempt:Int;

    /**
        Creates a new Flow.

        @param filterFunc A function which is executed for every request listed by the `Processor`
        to which `this` Flow is attached. All requests for which the function returns `true` will
        be processed by `this` Flow when the Processor runs.
    **/
    public function new(filterFunc:FilterFunc) {
        this.filterFunc = filterFunc;
        this.skipRequestOnPendingMigration = true;
        this.executor = new FlowExecutor(this, this);
        this.logger = new FlowLogger(this.getClassName());
        this.store = new FlowStore(this);
        this.request = null;
        this.data = new Dictionary();
        this.volatileData = new Dictionary();
        this.firstStep = 0;
        this.lastRequestState = null;
        this.stepAttempt = 0;
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

    /**
        Enables or disables storing of request data when the Flow fails execution. Defaults to true.
    **/
    public function setStoreRequestOnFailure(enable:Bool):Void {
        this.store.setStoreRequestOnFailure(enable);
    }

    /**
        Tells if the flow stores request data when Flow execution fails.
    **/
    public function storesRequestOnFailure():Bool {
        return this.store.storesRequestOnFailure();
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

        @param description Description of what the step does, so the Flow can indicate it in the log.
        @param func The function to execute for this step. It receives `this` Flow as argument, and it cannot return a value.
        @returns `this` Flow, so calls to this method can be chained.
    **/
    public function step(description:String, func:StepFunc):Flow {
        this.executor.addStep(description, func);
        return this;
    }

    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `AssetRequest` type.

        @returns The `AssetRequest` being processed, or `null` if current request is not of
        Fulfillment api.
    **/
    public function getAssetRequest():AssetRequest {
        return RequestCaster.castAssetRequest(this.request);
    }

    /**
        This can be called within your steps to get the element being processed, as long as it
        is of the `Listing` type.

        @returns The `Listing` being processed, or `null` if current element is not of
        Listing api.
    **/
    public function getListing():Listing {
        return RequestCaster.castListing(this.request);
    }

    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `TierConfigRequest` type.

        @returns The `TierConfigRequest` being processed, or `null` if current request is not of
        Tier api.
    **/
    public function getTierConfigRequest():TierConfigRequest {
        return RequestCaster.castTierConfigRequest(this.request);
    }

    /**
        This can be called within your steps to get the request being processed, as long as it
        is of the `UsageFile` type.

        @returns The `UsageFile` being processed, or `null` if current request is not of
        Usage api.
    **/
    public function getUsageFile():UsageFile {
        return RequestCaster.castUsageFile(this.request);
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
        This method follows the same goal as `setData`, but the data established with
        this method never gets saved in case processing fails. So this is ideal
        for storing data that can be safely recomputed on next execution, and we do
        not need to retrieve from saved data. If we store a value with both `setVolatileData`
        and `setData`, then `getData` will retrieve the persistent version set with `setData`,
        so be careful about that behaviour.
    **/
    public function setVolatileData(key:String, value:Dynamic):Flow {
        this.volatileData.set(key, value);
        return this;
    }

    /**
        Retrieves Flow data previously set with `setData` or `setVolatileData`.
        If the data has been set both as persistent as volatile, the persistent
        version is obtained.
        @param key The name of the key that identifies the data to be obtained.
        @returns The value of the data, or `null` if the key does not exist.
    **/
    public function getData(key:String):Dynamic {
        if (this.data.exists(key)) {
            return this.data.get(key);
        } else {
            return this.volatileData.get(key);
        }
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
            this.store.removeStepData(request);
            request.update(null);
            request.approveByTemplate(id);
            this.abort('');
        } else if (tcr != null) {
            this.store.removeStepData(tcr);
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
            this.store.removeStepData(request);
            request.update(null);
            request.approveByTile(text);
            this.abort('');
        } else if (tcr != null) {
            this.store.removeStepData(request);
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
            this.store.removeStepData(request);
            request.update(null);
            request.fail(reason);
            this.abort('Failing request');
        } else if (tcr != null) {
            this.store.removeStepData(request);
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
            this.store.removeStepData(request);
            request.update(params);
            request.inquire(templateId);
            this.abort('Inquiring request');
        } else if (tcr != null) {
            this.store.removeStepData(request);
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
            this.store.removeStepData(request);
            request.update(null);
            request.pend();
            this.abort('Pending request');
        } else if (tcr != null) {
            this.store.removeStepData(request);
            tcr.update(null);
            tcr.pend();
            this.abort('Pending request');
        }
    }

    /**
        Skips processing of the current request. Pending steps for the request will not be executed,
        and step data will be stored so it can be resumed in the next execution.
    **/
    private function skip():Void {
        this.executor.abort();
    }

    /**
        Aborts processing of the current request. Pending steps for the request will not be executed,
        and `message` is printed if it is not an empty string or `null`.
    **/
    private function abort(message:String):Void {
        this.executor.abort((message != null) ? message : '');
    }

    @:dox(hide)
    public function _run<T>(list:Collection<T>):Void {
        this.logger.openFlowSection();
        final filteredList = this.filterRequests(list);
        Lambda.iter(filteredList, model -> this.runRequest(cast(model, IdModel)));
        this.logger.closeFlowSection();
    }

    private function filterRequests<T>(list:Collection<T>):Collection<T> {
        return (this.filterFunc != null)
            ? Collection._fromArray(list.toArray().filter(callRequestFilter))
            : list;
    }

    private function callRequestFilter<T>(m:T):Bool {
    #if cslib
        return this.filterFunc.Invoke(cast(m, IdModel));
    #elseif javalib
        return this.filterFunc.apply(cast(m, IdModel));
    #else
        return this.filterFunc(cast(m, IdModel));
    #end
    }

    private function runRequest(request:IdModel):Void {
        this.logger.openRequestSection(request);
        if (this.prepareRequest(request) && this.processSetup()) {
            this.store.requestDidBegin(this.request);
            this.executor.executeRequest(request, this.firstStep);
        } else {
            this.logger.writeMigrationMessage(request);
        }
        this.logger.closeRequestSection();
    }

    private function prepareRequest(request:IdModel):Bool {
        this.request = request;
        this.data = new Dictionary();
        this.volatileData = new Dictionary();
        this.firstStep = 0;
        this.lastRequestState = new ProcessedRequestInfo(null, null);
        this.stepAttempt = 1;
        final assetRequest = this.getAssetRequest();
        return assetRequest == null ||
            !assetRequest.needsMigration() || !skipsRequestOnPendingMigration() || assetRequest.type != 'purchase';
    }

    private function processSetup():Bool {
        this.logger.openSetupSection();
        var ok = true;
        try {
            this.setup();
        } catch (ex:Dynamic) {
            final exStr = getExceptionMessage(ex);
            this.logger.writeException(ex);
            if (this.getAssetRequest() != null) {
                this.getAssetRequest()._updateConversation(SKIP_MSG + exStr);
            }
            ok = false;
        }
        this.logger.closeSetupSection();
        return ok;
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

    /**
     * Provide current step attempt.
     * @return Int Number of times that this step has been executed
    **/
    public function getCurrentAttempt() {
        return this.stepAttempt;
    }

    public function onStepBegin(request:IdModel, step:Step, index:Int):Void {
        this.logger.openStepSection(index, step.getDescription());
        this.logger.writeStepInfo(new ProcessedRequestInfo(this.request, this.data), lastRequestState);
    }

    public function onStepEnd(request:IdModel, step:Step, index:Int):Void {
        this.stepAttempt = 1;
        this.store.removeStepData(request);
        this.logger.closeStepSection(index);
    }

    public function onStepFail(request:IdModel, step:Step, index:Int, msg:String):Void {
        this.logger.writeStepError(new ProcessedRequestInfo(this.request, this.data), lastRequestState);
        this.logger.writeException(msg);
        if (this.getAssetRequest() != null) {
            this.getAssetRequest()._updateConversation(SKIP_MSG + msg);
        }
        this.logger.closeStepSection(index);
    }

    public function onStepSkip(request:IdModel, step:Step, index:Int):Void {
        this.logger.writeStepSkip(this.storesRequestOnFailure());
        this.store.requestDidSkip(this.request, this.data, index, this.stepAttempt + 1);
        this.logger.closeStepSection(index);
    }

    public function onStepAbort(request:IdModel, step:Step, index:Int, msg:String):Void {
        if (msg != '') {
            this.logger.writeException(msg);
        }
        this.logger.closeStepSection(index);
    }

    public function onLoad(request:IdModel, firstStep:Int, data:Dictionary, storageType:String, numAttempts:Int):Void {
        this.firstStep = firstStep;
        this.data = data;
        this.volatileData = new Dictionary();
        this.stepAttempt = numAttempts;
        this.logger.writeLoadedStepData(firstStep, storageType);
    }

    public function onFailedLoad(request:IdModel):Void { }

    public function onConnectSave(request:IdModel):Void {
        this.logger.writeStepSavedInConnect();
    }

    public function onLocalSave(request:IdModel):Void {
        this.logger.writeStepSavedLocally();
    }

    public function onFailedSave(request:IdModel):Void {
        this.logger.writeStepSaveFailed();
    }
}
