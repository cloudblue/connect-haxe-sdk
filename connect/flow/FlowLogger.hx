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

@:dox(hide)
class FlowLogger {
    private final flowName:String;
    private var currentRequest:Null<IdModel>;

    public function new(flowName: String) {
        this.flowName = flowName;
    }

    public function openFlowSection():Void {
        cleanLogContext();
        Env.getLoggerForRequest(currentRequest).openSection('Running ${this.flowName} on ${DateTime.now()}');
    }

    public function closeFlowSection():Void {
        Env.getLoggerForRequest(currentRequest).closeSection();
        currentRequest = null;
    }

    private function cleanLogContext(): Void{
        final requestLogger = Env.getLoggerForRequest(currentRequest);
        for (handler in requestLogger.getHandlers()){
            handler.formatter.setRequest(null);
        }
    }
    public function openRequestSection(request:IdModel):Void {
        currentRequest = request;
        Env.getLoggerForRequest(currentRequest).openSection('Processing request "${request.id}" on ${DateTime.now()}');
    }

    public function closeRequestSection():Void {
        Env.getLoggerForRequest(currentRequest).closeSection();
        currentRequest = null;
        cleanLogContext();
    }

    public function openSetupSection():Void {
        Env.getLoggerForRequest(currentRequest).openSection('Setup');
    }

    public function closeSetupSection():Void {
        Env.getLoggerForRequest(currentRequest).closeSection();
    }

    public function openStepSection(index:Int, description:String):Void {
        Env.getLoggerForRequest(currentRequest).openSection('${index + 1}. $description');
    }

    public function closeStepSection(index:Int):Void {
        Env.getLoggerForRequest(currentRequest).closeSection();
    }

    public function writeStepInfo(requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo) {
        writeStep(Logger.LEVEL_INFO, requestInfo, prevRequestInfo);
    }

    public function writeStepError(requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo) {
        if (Env.getLoggerForRequest(currentRequest).getLevel() == Logger.LEVEL_ERROR) {
            writeStep(Logger.LEVEL_ERROR, requestInfo, prevRequestInfo);
        }
    }

    private function writeStep(level:Int, requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo):Void {
        for (handler in Env.getLoggerForRequest(currentRequest).getHandlers()) {
            final list = new Collection<String>()
            .push(getFormattedRequest(requestInfo.getRequestString(), prevRequestInfo.getRequestString(), handler.formatter))
            .push(getFormattedData(requestInfo.getDataString(), prevRequestInfo.getDataString(), requestInfo.getData(), handler.formatter));
            Env.getLoggerForRequest(currentRequest)._writeToHandler(level, handler.formatter.formatList(level,list), handler);
        }
    }

    private function getFormattedRequest(request:String, lastRequest:String, fmt:ILoggerFormatter):String {
        if (request != lastRequest) {
            if (Env.getLoggerForRequest(currentRequest).getLevel() == Logger.LEVEL_DEBUG) {
                final lastRequestObj = Util.isJsonObject(lastRequest) ? Json.parse(lastRequest) : null;
                final requestObj = (Util.isJsonObject(request) && lastRequestObj != null) ? Json.parse(request) : null;
                final diff = (lastRequestObj != null && requestObj != null) ? Util.createObjectDiff(requestObj, lastRequestObj) : null;
                final requestStr = (diff != null)
                ? Util.beautifyObject(
                    diff,
                    Env.getLoggerForRequest(currentRequest).isCompact(),
                    false,
                    Env.getLoggerForRequest(currentRequest).isBeautified())
                : request;
                final requestTitle = (diff != null) ? 'Request (changes):' : 'Request:';
                return '$requestTitle${fmt.formatCodeBlock(Env.getLoggerForRequest(currentRequest).getLevel(),Std.string(requestStr), 'json')}';
            } else {
                return 'Request (id): ${request}';
            }
        } else {
            return 'Request: Same as in previous step.';
        }
    }

    private function getFormattedData(data:String, lastData:String, dataDict:Null<Dictionary>, fmt:ILoggerFormatter):String {
        if (data != '{}') {
            if (data != lastData) {
                if (Env.getLoggerForRequest(currentRequest).getLevel() == Logger.LEVEL_DEBUG) {
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

    private function getDataTable(data:Dictionary, fmt:ILoggerFormatter):String {
        final dataKeys = [for (key in data.keys()) key];
        final dataCol = new Collection<Collection<String>>().push(new Collection<String>().push('Key').push('Value'));
        Lambda.iter(dataKeys, function(key) {
            dataCol.push(new Collection<String>().push(key).push(data.get(key)));
        });
        return fmt.formatTable(Env.getLoggerForRequest(currentRequest).getLevel(),dataCol);
    }

    public function writeStepSkip(willSave:Bool) {
        if (willSave) {
            Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Skipping request. Trying to save step data.');
        } else {
            Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Skipping request. Step data will not be saved because feature is disabled.');
        }
    }

    public function writeStepSavedInConnect() {
        Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Step data saved in Connect.');
    }

    public function writeStepSavedLocally() {
        Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Step data saved locally.');
    }

    public function writeStepSaveFailed() {
        Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Step data could not be saved.');
    }

    public function writeMigrationMessage(request:IdModel):Void {
        this.openRequestSection(request);
        Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Skipping request because it is pending migration.');
        this.closeRequestSection();
    }

    public function writeException(message:String):Void {
        Env.getLoggerForRequest(currentRequest).writeCodeBlock(Logger.LEVEL_ERROR, message, '');
    }

    public function writeLoadedStepData(index:Int, storageType:String):Void {
        Env.getLoggerForRequest(currentRequest).write(Logger.LEVEL_INFO, 'Resuming request from step ${index + 1} with $storageType.');
    }

    private function setContextRequest(requestId:Null<String>):Void {
        for (handler in Env.getLoggerForRequest(currentRequest).getHandlers()){
            handler.formatter.setRequest(requestId);
        }
    }
}
