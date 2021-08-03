/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

package connect;

import connect.api.ConnectHelper;
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
class Flow extends Base implements FlowExecutorDelegate {
    private static final SKIP_MSG = 'Skipping request because an exception was thrown: ';

    private final filterFunc:FilterFunc;
    private var skipRequestOnPendingMigration:Bool;
    private final executor:FlowExecutor;
    private final logger:FlowLogger;
    private var request:IdModel;
    private var data:Dictionary;
    private var lastRequestState:ProcessedRequestInfo;

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
        this.request = null;
        this.data = new Dictionary();
        this.lastRequestState = null;
    }

    private function getClassName():String {
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

    /** This method is deprecated and has no effect. **/
    public function setStoreRequestOnFailure(enable:Bool):Void {
    }

    /** This method is deprecated and always returns false. **/
    public function storesRequestOnFailure():Bool {
        return false;
    }

    /**
        This method is deprecated and has no effect.
    **/
    public function setStoreNumAttempts(enable:Bool):Void {
    }

    /** This method is deprecated and always returns false. **/
    public function storesNumAttempts():Bool {
        return false;
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
        This method is executed every time a new request is going to begin processing.
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
        later on with `getData`. It is recommended for the correct function of the Flow
        to only rely on the data set using this mechanism, and not to add additional properties
        when creating a subclass of Flow, since these wouldn't be automatically reset for each request
        processed.

        @param key The name of the key that will be used to identify this data.
        @param value The value to store.
        @returns `this` Flow, so calls to this method can be chained.
    **/
    public function setData(key:String, value:Dynamic):Flow {
        this.data.set(key, value);
        return this;
    }

    /** This method is deprecated and currently just calls `setData`. **/
    public function setVolatileData(key:String, value:Dynamic):Flow {
        return setData(key, value);
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
        `TierConfigRequest.approveByTemplate()`, since this automatically skips any further steps.
    **/
    public function approveByTemplate(id:String):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            request.update(null);
            request.approveByTemplate(id);
            this.abort('');
        } else if (tcr != null) {
            tcr.update(null);
            tcr.approveByTemplate(id);
            this.abort('');
        }
    }

    /**
        Changes the status of the request being processed to "approved", rendering a tile on
        the portal with the given Markdown `text`.

        When using the Flow, this method should be used instead of `AssetRequest.approveByTile()` or
        `TierConfigRequest.approveByTile()`, since this automatically skips any further steps.
    **/
    public function approveByTile(text:String):Void {
        final request = this.getAssetRequest();
        if (request != null) {
            request.update(null);
            request.approveByTile(text);
            this.abort('');
        }
    }

    /**
        Changes the status of the request being processed to "failed".

        When using the Flow, this method should be used instead of `AssetRequest.fail()` or
        `TierConfigRequest.fail()`, since this skips any further steps.
    **/
    public function fail(reason:String):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            request.update(null);
            request.fail(reason);
            this.abort('Failing request');
        } else if (tcr != null) {
            tcr.update(null);
            tcr.fail(reason);
            this.abort('Failing request');
        }
    }

    /**
        Changes the status of the request being processed to "inquiring".

        When using the Flow, this method should be used instead of `AssetRequest.inquire()` or
        `TierConfigRequest.inquire()`, since this skips any further steps.
        Also, this method calls `update` on the request before changing its status.

        @param templateId Id of the template to use in the portal, or `null` to not use any. This
        is only used for AssetRequests.
        @param params A collection of parameters to update. If `null` is passed, then the
        parameters that have changed in the request will be updated.
    **/
    public function inquire(templateId:String, params: Collection<Param>):Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            request.update(params);
            request.inquire(templateId);
            this.abort('Inquiring request');
        } else if (tcr != null) {
            tcr.update(params);
            tcr.inquire();
            this.abort('Inquiring request');
        }
    }

    /**
        Changes the status of the request being processed to "pending".

        When using the Flow, this method should be used instead of `AssetRequest.pend()` or
        `TierConfigRequest.pend()`, since this automatically skips any further steps.
    **/
    public function pend():Void {
        final request = this.getAssetRequest();
        final tcr = this.getTierConfigRequest();
        if (request != null) {
            request.update(null);
            request.pend();
            this.abort('Pending request');
        } else if (tcr != null) {
            tcr.update(null);
            tcr.pend();
            this.abort('Pending request');
        }
    }

    /**
        Skips processing of the current request. Pending steps for the request will not be executed.
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
        ConnectHelper.setLogger(Env.getLoggerForRequest(request));
        this.logger.openRequestSection(request);
        if (this.prepareRequest(request) && this.processSetup()) {
            this.executor.executeRequest(request, 0);
        } else {
            this.logger.writeMigrationMessage(request);
        }
        this.logger.closeRequestSection();
        ConnectHelper.setLogger(Env.getLogger());
    }

    private function prepareRequest(request:IdModel):Bool {
        this.request = request;
        this.data = new Dictionary();
        this.lastRequestState = new ProcessedRequestInfo(null, null);
        final assetRequest = this.getAssetRequest();
        return assetRequest == null ||
            !assetRequest.needsMigration() || !skipsRequestOnPendingMigration() || assetRequest.type != 'purchase';
    }

    private function processSetup():Bool {
        this.logger.openSetupSection();
        var ok = true;
        try {
            this.executor.reset();
            this.setup();
        } catch (ex:Dynamic) {
            this.logger.writeException(FlowExecutor.getStackTrace(ex));
            if (this.getAssetRequest() != null) {
                this.getAssetRequest()._updateConversation(SKIP_MSG + FlowExecutor.getExceptionMessage(ex));
            }
            ok = false;
        }
        this.logger.closeSetupSection();
        return ok;
    }

    /**
     * This method is deprecated, and always returns 0.
     * @return Int Number of times that this step has been executed
    **/
    public function getCurrentAttempt() {
        return 0;
    }

    @:dox(hide)
    public function onStepBegin(request:IdModel, step:Step, index:Int):Void {
        this.logger.openStepSection(index, step.getDescription());
        this.logger.writeStepInfo(new ProcessedRequestInfo(this.request, this.data), lastRequestState);
    }

    @:dox(hide)
    public function onStepEnd(request:IdModel, step:Step, index:Int):Void {
        this.logger.closeStepSection(index);
    }

    @:dox(hide)
    public function onStepFail(request:IdModel, step:Step, index:Int, msg:String):Void {
        this.logger.writeStepError(new ProcessedRequestInfo(this.request, this.data), lastRequestState);
        this.logger.writeException(msg);
        if (this.getAssetRequest() != null) {
            this.getAssetRequest()._updateConversation(SKIP_MSG + msg);
        }
        this.logger.closeStepSection(index);
    }

    @:dox(hide)
    public function onStepSkip(request:IdModel, step:Step, index:Int):Void {
        this.logger.writeStepSkip();
        this.logger.closeStepSection(index);
    }

    @:dox(hide)
    public function onStepAbort(request:IdModel, step:Step, index:Int, msg:String):Void {
        if (msg != '') {
            this.logger.writeException(msg);
        }
        this.logger.closeStepSection(index);
    }
}
