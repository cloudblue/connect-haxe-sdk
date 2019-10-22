package connect;

import connect.api.QueryParams;
import connect.models.IdModel;
import connect.models.Request;
import haxe.Constraints.Function;


#if java
typedef ProcessorStepFunc = connect.native.JavaBiFunction<Processor, String, String>;
#else
typedef ProcessorStepFunc = (Processor, String) -> String;
#end


/**
    In development. Do not use by now...
**/
class Processor {
    public function new() {
        this.steps = [];
    }


    public function step(description: String, func: ProcessorStepFunc): Processor {
        this.steps.push(new Step(description, func));
        return this;
    }


    public function run<T>(modelClass: Class<T>, filters: QueryParams): Void {
        // On some targets, a string is received as modelClass, so obtain the real class from it
        switch (Type.typeof(modelClass)) {
            case TClass(String):
                modelClass = untyped Type.resolveClass(cast(modelClass, String));
            default:
        }
        
        Env.getLogger().openSection('Running processor on ' + getDate());

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
            this.model = model;
            this.data = new Dictionary();
            this.skip_ = false;
            this.saveStep = false;
            var input: String = null;
            var lastRequestStr = '';
            var lastDataStr = '{}';


            Env.getLogger().openSection('Processing request "${this.model.id}" on ' + getDate());

            // For Fulfillment requests, check if we must skip due to pending migration
            if (this.getRequest() != null && this.getRequest().needsMigration()) {
                Env.getLogger().info('Skipping request because it is pending migration.');
            } else {
                var firstIndex = 0;

                // If there is stored step data, set data and jump to that step
                if (this.getRequest() != null
                        && this.getRequest().asset.getParamById(STEP_PARAM_ID) != null
                        && this.getRequest().asset.getParamById(STEP_PARAM_ID).value != null
                        && this.getRequest().asset.getParamById(STEP_PARAM_ID).value != '') {
                    var param = this.getRequest().asset.getParamById(STEP_PARAM_ID);
                    if (param.value != null && Inflection.isJsonObject(param.value)) {
                        var stepData = haxe.Json.parse(param.value);
                        firstIndex = stepData.current_step;
                        input = stepData.input;
                        var fields: Array<String> = Reflect.fields(stepData.data);
                        for (field in fields) {
                            var value = Reflect.field(stepData.data, field);
                            var parsedData = this.parseSavedData(field, value);
                            this.setData(field, parsedData);
                        }
                    }
                    Env.getLogger().info('Resuming request from step ${firstIndex + 1}');
                }

                // Process each step
                for (index in firstIndex...this.steps.length) {
                    var step = this.steps[index];
                    var requestStr = Inflection.beautify(this.model.toString(),
                        Env.getLogger().getLevel() != Logger.LEVEL_DEBUG);
                    var dataStr = Std.string(this.data);
                    
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
                        Env.getLogger().error('```');
                        Env.getLogger().error(Std.string(ex));
                        Env.getLogger().error('```');
                        Env.getLogger().error('');
                        this.skip(true);
                    }

                    if (this.skip_) {
                        if (this.saveStep) {
                            Env.getLogger().info('Skipping request.');

                            // Save step data if request supports it
                            if (this.getRequest() != null &&
                                    this.getRequest().asset.getParamById(STEP_PARAM_ID) != null) {
                                Env.getLogger().info('Saving step data.');
                                var param = this.getRequest().asset.getParamById(STEP_PARAM_ID);
                                param.value = haxe.Json.stringify({
                                    current_step: index,
                                    input: input,
                                    data: this.data.toObject(),
                                });
                                try {
                                    this.getRequest().update();
                                } catch (ex: Dynamic) {
                                    Env.getLogger().error('```');
                                    Env.getLogger().error(Std.string(ex));
                                    Env.getLogger().error('```');
                                    Env.getLogger().error('');
                                }
                            }
                        }

                        Env.getLogger().closeSection();
                        break;
                    } else {
                        Env.getLogger().closeSection();

                        lastRequestStr = requestStr;
                        lastDataStr = dataStr;
                    }
                }
            }

            Env.getLogger().closeSection();
        }
        Env.getLogger().closeSection();
    }

    
    public function getRequest(): Request {
        return cast(this.model, Request);
    }


    public function setData(key: String, value: Dynamic): Processor {
        this.data.set(key, value);
        return this;
    }
    
    
    public function getData(key: String): Dynamic {
        return this.data.get(key);
    }


    /**
        Changes the status of the Request being processed to "approved", sending the id
        of a Template to render on the portal.

        When using the Processor, this method should be used instead of
        `Request.approveByTemplate()`, since this take care of cleaning the stored step
        information, and automatically calls `skip` to avoid processing any further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function approveByTemplate(id: String): Request {
        var request = this.getRequest();
        if (request != null) {
            var param = request.asset.getParamById(STEP_PARAM_ID);
            if (param != null) {
                param.value = '';
            }
            request.update();
            var result = request.approveByTemplate(id);
            this.skip(false);
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "approved", rendering a tile on
        the portal with the given Markdown `text`.

        When using the Processor, this method should be used instead of `Request.approveByTile()`,
        since this take care of cleaning the stored step information, and automatically calls
        `skip` to avoid processing any further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function approveByTile(text: String): Request {
        var request = this.getRequest();
        if (request != null) {
            var param = request.asset.getParamById(STEP_PARAM_ID);
            if (param != null) {
                param.value = '';
            }
            request.update();
            var result = request.approveByTile(text);
            this.skip(false);
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "failed".

        When using the Processor, this method should be used instead of `Request.fail()`,
        since this take care of cleaning the stored step information, and automatically calls
        `skip` to avoid processing any further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function fail(reason: String): Request {
        var request = this.getRequest();
        if (request != null) {
            var param = request.asset.getParamById(STEP_PARAM_ID);
            if (param != null) {
                param.value = '';
            }
            request.update();
            var result = request.fail(reason);
            this.skip(false);
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "inquiring".

        When using the Processor, this method should be used instead of `Request.inquire()`,
        since this take care of cleaning the stored step information, and automatically calls
        `skip` to avoid processing any further steps.

        @returns The Request returned from the server, which should contain
        the updated status.
    **/
    public function inquire(): Request {
        var request = this.getRequest();
        if (request != null) {
            var param = request.asset.getParamById(STEP_PARAM_ID);
            if (param != null) {
                param.value = '';
            }
            request.update();
            var result = request.inquire();
            this.skip(false);
            return result;
        } else {
            return null;
        }
    }


    /**
        Changes the status of the Request being processed to "pending".

        When using the Processor, this method should be used instead of `Request.pend()`,
        since this take care of cleaning the stored step information, and automatically calls
        `skip` to avoid processing any further steps.

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
            this.skip(false);
            return result;
        } else {
            return null;
        }
    }
    

    private static inline var STEP_PARAM_ID = '__sdk_processor_step';
    
    private var steps: Array<Step>;
    private var model: IdModel;
    private var data: Dictionary;
    private var skip_: Bool;
    private var saveStep: Bool;


    private function skip(saveStep: Bool): Void {
        this.skip_ = true;
        this.saveStep = saveStep;
    }


    private function parseSavedData(key: String, value: Dynamic): Dynamic {
        return value;
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
}


private class Step {
    public var description: String;
    public var func: ProcessorStepFunc;

    public function new(description: String, func: ProcessorStepFunc) {
        this.description = description;
        this.func = func;
    }
}
