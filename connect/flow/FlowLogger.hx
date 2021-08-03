package connect.flow;

import connect.logger.ILoggerFormatter;
import connect.logger.Logger;
import connect.models.IdModel;
import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Dictionary;
import connect.util.Masker;
import connect.util.Util;
import haxe.Json;

@:dox(hide)
class FlowLogger {
    private final flowName:String;
    private var logger:Logger;

    public function new(flowName: String) {
        this.flowName = flowName;
        this.logger = Env.getLogger();
    }

    public function openFlowSection():Void {
        logger.openSection('Running ${this.flowName} on ${DateTime.now()}');
    }

    public function closeFlowSection():Void {
        logger.closeSection();
        logger = Env.getLogger();
    }

    public function openRequestSection(request:IdModel):Void {
        logger = Env.getLoggerForRequest(request);
        logger.openSection('Processing request "${request.id}" on ${DateTime.now()}');
    }

    public function closeRequestSection():Void {
        logger.closeSection();
        logger = Env.getLogger();
    }

    public function openSetupSection():Void {
        logger.openSection('Setup');
    }

    public function closeSetupSection():Void {
        logger.closeSection();
    }

    public function openStepSection(index:Int, description:String):Void {
        logger.openSection('${index + 1}. $description');
    }

    public function closeStepSection(index:Int):Void {
        logger.closeSection();
    }

    public function writeStepInfo(requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo) {
        writeStep(Logger.LEVEL_INFO, requestInfo, prevRequestInfo);
    }

    public function writeStepError(requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo) {
        if (logger.getLevel() == Logger.LEVEL_ERROR) {
            writeStep(Logger.LEVEL_ERROR, requestInfo, prevRequestInfo);
        }
    }

    private function writeStep(level:Int, requestInfo:ProcessedRequestInfo, prevRequestInfo:ProcessedRequestInfo):Void {
        for (handler in logger.getHandlers()) {
            final list = new Collection<String>()
                .push(getFormattedRequest(requestInfo.getRequestString(), prevRequestInfo.getRequestString(), handler.formatter))
                .push(getFormattedData(requestInfo.getDataString(), prevRequestInfo.getDataString(), requestInfo.getData(), handler.formatter));
            logger._writeToHandler(level, handler.formatter.formatList(level,list), handler);
        }
    }

    private function getFormattedRequest(request:String, lastRequest:String, fmt:ILoggerFormatter):String {
        if (request != lastRequest) {
            if (logger.getLevel() == Logger.LEVEL_DEBUG) {
                final lastRequestObj = Util.isJsonObject(lastRequest) ? Json.parse(lastRequest) : null;
                final requestObj = (Util.isJsonObject(request) && lastRequestObj != null) ? Json.parse(request) : null;
                final diff = (lastRequestObj != null && requestObj != null) ? Util.createObjectDiff(requestObj, lastRequestObj) : null;
                final requestStr =
                    (diff == null) ? request :
                    (Env.getLogger().getLevel() != Logger.LEVEL_DEBUG) ? Masker.maskObject(diff) : 
                    haxe.Json.stringify(diff);
                final requestTitle = (diff != null) ? 'Request (changes):' : 'Request:';
                return '$requestTitle${fmt.formatCodeBlock(logger.getLevel(),Std.string(requestStr), 'json')}';
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
                if (logger.getLevel() == Logger.LEVEL_DEBUG) {
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
        return fmt.formatTable(logger.getLevel(),dataCol);
    }

    public function writeStepSkip(willSave:Bool) {
        if (willSave) {
            logger.write(Logger.LEVEL_INFO, 'Skipping request. Trying to save step data.');
        } else {
            logger.write(Logger.LEVEL_INFO, 'Skipping request. Step data will not be saved because feature is disabled.');
        }
    }

    public function writeStepSavedInConnect() {
        logger.write(Logger.LEVEL_INFO, 'Step data saved in Connect.');
    }

    public function writeStepSavedLocally() {
        logger.write(Logger.LEVEL_INFO, 'Step data saved locally.');
    }

    public function writeStepSaveFailed() {
        logger.write(Logger.LEVEL_INFO, 'Step data could not be saved.');
    }

    public function writeMigrationMessage(request:IdModel):Void {
        logger.write(Logger.LEVEL_INFO, 'Skipping request because it is pending migration.');
    }

    public function writeException(message:String):Void {
        logger.writeCodeBlock(Logger.LEVEL_ERROR, message, '');
    }

    public function writeLoadedStepData(index:Int, storageType:String):Void {
        logger.write(Logger.LEVEL_INFO, 'Resuming request from step ${index + 1} with $storageType.');
    }
}
