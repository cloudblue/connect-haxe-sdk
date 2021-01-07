package connect.flow;

import connect.util.Dictionary;
import haxe.Json;
import connect.util.Util;
import connect.logger.ILoggerFormatter;
import connect.util.Collection;
import connect.logger.Logger;
import connect.models.AssetRequest;
import connect.models.IdModel;
import connect.models.Listing;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;
import connect.util.DateTime;
import connect.logger.PlainLoggerFormatter;

@:dox(hide)
class FlowLogger {
    private final flowName:String;

    public function new(flowName: String) {
        this.flowName = flowName;
    }

    public function openFlowSection():Void {
        Env.getLogger().openSection('Running ${this.flowName} on ${DateTime.now()}');
    }

    public function closeFlowSection():Void {
        Env.getLogger().closeSection();
        Env.getLogger().setFilename(null);
        this.setContextRequest(null);
    }

    public function openRequestSection(request:IdModel):Void {
        Env.getLogger().setFilenameFromRequest(request);
        this.setContextRequest(request.id);
        Env.getLogger().openSection('Processing request "${request.id}" on ${DateTime.now()}');
    }

    public function closeRequestSection():Void {
        Env.getLogger().closeSection();
    }

    public function openSetupSection():Void {
        Env.getLogger().openSection('Setup');
    }

    public function closeSetupSection():Void {
        Env.getLogger().closeSection();
    }

    public function openStepSection(index:Int, description:String):Void {
        Env.getLogger().openSection('${index + 1}. $description');
    }

    public function closeStepSection(index:Int):Void {
        Env.getLogger().closeSection();
    }

    public function writeStepInfo(requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo) {
        writeStep(Logger.LEVEL_INFO, requestInfo, prevRequestInfo);
    }

    public function writeStepError(requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo) {
        if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
            writeStep(Logger.LEVEL_ERROR, requestInfo, prevRequestInfo);
        }
    }

    private static function writeStep(level:Int, requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo):Void {
        for (handler in Env.getLogger().getHandlers()) {
            final list = new Collection<String>()
                .push(getFormattedRequest(requestInfo.getRequestString(), prevRequestInfo.getRequestString(), handler.formatter))
                .push(getFormattedData(requestInfo.getDataString(), prevRequestInfo.getDataString(), requestInfo.getData(), handler.formatter));
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

    private static function getFormattedData(data:String, lastData:String, dataDict:Null<Dictionary>, fmt:ILoggerFormatter):String {
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

    public function writeStepSkip(willSave:Bool) {
        if (willSave) {
            Env.getLogger().write(Logger.LEVEL_INFO, 'Skipping request. Trying to save step data.');
        } else {
            Env.getLogger().write(Logger.LEVEL_INFO, 'Skipping request. Step data will not be saved because feature is disabled.');
        }
    }

    public function writeStepSavedInConnect() {
        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data saved in Connect.');
    }

    public function writeStepSavedLocally() {
        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data saved locally.');
    }

    public function writeStepSaveFailed() {
        Env.getLogger().write(Logger.LEVEL_INFO, 'Step data could not be saved.');
    }

    public function writeMigrationMessage(request:IdModel):Void {
        this.openRequestSection(request);
        Env.getLogger().write(Logger.LEVEL_INFO, 'Skipping request because it is pending migration.');
        this.closeRequestSection();
    }

    public function writeException(message:String):Void {
        Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, message, '');
    }

    public function writeLoadedStepData(index:Int, storageType:String):Void {
        Env.getLogger().write(Logger.LEVEL_INFO, 'Resuming request from step ${index + 1} with $storageType.');
    }

    private function setContextRequest(requestId:Null<String>):Void {
        for (handler in Env.getLogger().getHandlers()){
            handler.formatter.setRequest(requestId);
        }
    }
}
