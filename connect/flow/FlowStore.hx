package connect.flow;

import connect.models.IdModel;
import connect.models.Param;
import connect.storage.StepData;
import connect.storage.StepStorage;
import connect.util.Dictionary;

@:dox(hide)
class FlowStore {
    private static final STEP_PARAM_ID = '__sdk_processor_step';
    private static final STEP_PARAM_ID_TIER = '__sdk_processor_step_tier';
    private static final STEP_PARAM_ID_TIER2 = '__sdk_processor_step_tier2';

    private final observer:FlowStoreObserver;

    public function new(observer:Null<FlowStoreObserver>) {
        this.observer = observer;
    }

    public function loadStepData(request:IdModel):Void {
        final stepData = StepStorage.load(request.id, getStepParam(request));
        if (this.observer != null) {
            if (stepData.storage != FailedStorage) {
                this.observer.onLoad(request, stepData.firstIndex, stepData.data, Std.string(stepData.storage),
                    (stepData.attempt != null) ? stepData.attempt : 0);
            } else {
                this.observer.onFailedLoad(request);
            }
        }
    }

    public function saveStepData(request:IdModel, data:Dictionary, index:Int, attempt:Int):Void {
        final result = StepStorage.save(request, new StepData(index, data, ConnectStorage, attempt),
            this.getStepParam(request), Reflect.field(request, 'update'));
        if (this.observer != null) {
            switch (result) {
                case ConnectStorage:
                    observer.onConnectSave(request);
                case LocalStorage:
                    observer.onLocalSave(request);
                case FailedStorage:
                    observer.onFailedSave(request);
            }
        }
    }

    public function removeStepData(request:IdModel):Void {
        StepStorage.removeStepData(request.id, getStepParam(request));
    }

    private function getStepParam(request:IdModel):Param {
        final assetRequest = RequestCaster.castAssetRequest(request);
        final tierConfigRequest = RequestCaster.castTierConfigRequest(request);
        return
            (assetRequest != null) ? assetRequest.asset.getParamById(STEP_PARAM_ID) :
            (tierConfigRequest != null && tierConfigRequest.tierLevel == 1) ? tierConfigRequest.getParamById(STEP_PARAM_ID_TIER) :
            (tierConfigRequest != null && tierConfigRequest.tierLevel == 2) ? tierConfigRequest.getParamById(STEP_PARAM_ID_TIER2) :
            null;
    }
}
