package connect;

import connect.api.QueryParams;
import connect.models.IdModel;
import connect.models.Request;
import haxe.Constraints.Function;
import haxe.ds.StringMap;


#if java
typedef ProcessorStepFunc = connect.native.JavaBiFunction<Processor, String, String>;
#else
typedef ProcessorStepFunc = (Processor, String) -> String;
#end


class Processor {
    public function new() {
        this.steps = [];
    }


    public function step(description: String, func: ProcessorStepFunc): Processor {
        this.steps.push(new Step(description, func));
        return this;
    }


    public function run<T>(modelClass: Class<T>, filters: QueryParams): Void {
        var listMethod = Reflect.field(modelClass, 'list');
        
        Env.getLogger().openSection('Running processor on ' + getDate());

        // List requests
        Env.getLogger().openSection('Listing requests on ' + getDate());
        var list: Collection<IdModel> = Reflect.callMethod(modelClass, listMethod, [filters]);
        Env.getLogger().closeSection();
        
        // Process each request
        for (model in list) {
            this.model = model;
            this.data = new StringMap<String>();
            var input: String = null;
            var lastRequestStr = '';
            var lastDataStr = '{}';
            Env.getLogger().openSection('Processing request "${this.model.id}" on ' + getDate());            

            // Process each step
            for (index in 0...this.steps.length) {
                var step = this.steps[index];
                var requestStr = Inflection.beautify(this.model.toString(),
                    Env.getLogger().getLevel() != LoggerLevel.Debug);
                var dataStr = this.data.toString();
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
                    if (Env.getLogger().getLevel() == Error) {
                        this.logStepData(Env.getLogger().error, Inflection.beautify(input, false),
                            requestStr, dataStr, lastRequestStr, lastDataStr);
                    }
                    Env.getLogger().error('```');
                    Env.getLogger().error(Std.string(ex));
                    Env.getLogger().error('```');
                    Env.getLogger().error('');
                    input = null;
                }

                Env.getLogger().closeSection();

                lastRequestStr = requestStr;
                lastDataStr = dataStr;
            }

            Env.getLogger().closeSection();
        }
        Env.getLogger().closeSection();
    }

    
    public function getRequest(): Request {
        return cast(this.model, Request);
    }


    public function setData(key: String, value: String): Processor {
        this.data.set(key, value);
        return this;
    }
    
    
    public function getData(key: String): String {
        return this.data.get(key);
    }
    

    private var steps: Array<Step>;
    private var model: IdModel;
    private var data: StringMap<String>;


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
            if (Env.getLogger().getLevel() == Debug) {
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
                if (Env.getLogger().getLevel() == LoggerLevel.Debug) {
                    var keys = this.data.keys();
                    Reflect.callMethod(Env.getLogger(), func, ['* Data:']);
                    Reflect.callMethod(Env.getLogger(), func, ['| Key | Value |']);
                    Reflect.callMethod(Env.getLogger(), func, ['| --- | ----- |']);
                    for (key in keys) {
                        var val = this.getData(key);
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
