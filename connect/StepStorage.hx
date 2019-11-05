package connect;

import connect.models.IdModel;
import connect.models.Param;
import haxe.Constraints.Function;


@:dox(hide)
enum StoreResult {
    StoreConnect;
    StoreLocal;
    StoreFail;
}


@:dox(hide)
class StepStorage {
    public static function load(requestId: String, ?param: Param): StepData {
        if (param != null && param.value != null && param.value != ''
                && Inflection.isJsonObject(param.value)) {
            final storedData = haxe.Json.parse(param.value);
            if (Reflect.hasField(storedData, requestId)) {
                final stepData = Reflect.field(storedData, requestId);
                return new StepData(stepData.current_step, stepData.input, stepData.data);
            }
        }
        return new StepData(0, null, {});
    }


    public static function save(request: IdModel, stepData: StepData,
            ?param: Param, ?updateFunc: Function) : StoreResult {
        if (param != null) {
            final dataToSave: Dynamic = {};
            Reflect.setField(dataToSave, request.id, {
                current_step: stepData.firstIndex,
                input: stepData.input,
                data: stepData.data.toObject(),
            });
            param.value = haxe.Json.stringify(dataToSave);

            try {
                Reflect.callMethod(request, updateFunc, []);
                return StoreConnect;
            } catch (ex: Dynamic) {
                Env.getLogger().error('```');
                Env.getLogger().error(Std.string(ex));
                Env.getLogger().error('```');
                Env.getLogger().error('');
            }
        }
        return StoreFail;
    }
}
