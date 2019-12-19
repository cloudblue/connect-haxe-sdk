package connect;

import connect.StepData.StorageType;
import connect.models.IdModel;
import connect.models.Param;
import haxe.Constraints.Function;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;


@:dox(hide)
class StepStorage {
    public static function load(requestId: String, param: Param): StepData {
        final fileData = loadRequestFromFile(requestId);
        final stepData = (fileData != null)
            ? fileData
            : loadRequestFromParam(requestId, param);
        return (stepData != null)
            ? stepData
            : new StepData(0, {}, FailedStorage);
    }


    public static function save(request: IdModel, stepData: StepData,
            param: Param, updateFunc: Function) : StorageType {
        removeStepDataFromFile(request.id);

        // Save new data in available storage
        final paramObj = objWithRequestData(loadAllFromParam(param), request.id, stepData);
        final fileObj = objWithRequestData(loadAllFromFile(), request.id, stepData);
        if (saveInConnect(request, encodeData(paramObj), param, updateFunc)) {
            return ConnectStorage;
        } else if (saveInFile(encodeData(fileObj))) {
            return LocalStorage;
        } else {
            return FailedStorage;
        }
    }


    public static function removeStepData(requestId: String, param: Param): Bool {
        removeStepDataFromFile(requestId);

        final paramObj = loadAllFromParam(param);
        if (paramObj != null && Reflect.hasField(paramObj, requestId)) {
            param.value = encodeData(objWithoutRequestData(paramObj, requestId));
            return true; // Request needs updating
        }
        
        return false; // No need to update request
    }


    private static function removeStepDataFromFile(requestId: String): Void {
        final fileObj = loadAllFromFile();
        if (fileObj != null && Reflect.hasField(fileObj, requestId)) {
            final fileData = objWithoutRequestData(fileObj, requestId);
            saveInFile(encodeData(fileData));
        }
    }


    private static function objWithRequestData(obj: Dynamic, requestId: String,
            stepData: StepData): Dynamic {
        final fixedObj = (obj != null) ? obj : {};
        Reflect.setField(fixedObj, requestId, {
            current_step: stepData.firstIndex,
            data: stepData.data.toObject(),
        });
        return fixedObj;
    }


    private static function objWithoutRequestData(obj: Dynamic, requestId: String): Dynamic {
        final fixedObj = (obj != null) ? obj : {};
        if (Reflect.hasField(fixedObj, requestId)) {
            Reflect.deleteField(fixedObj, requestId);
        }
        return fixedObj;
    }


    private static function loadRequestFromParam(requestId: String, param: Param): StepData {
        final dataObject = loadAllFromParam(param);
        if (dataObject != null) {
            return getRequestField(dataObject, requestId, ConnectStorage);
        }
        return null;
    }


    private static function loadRequestFromFile(requestId: String): StepData {
        final dataObject = loadAllFromFile();
        if (dataObject != null) {
            return getRequestField(dataObject, requestId, LocalStorage);
        }
        return null;
    }


    private static function loadAllFromParam(param: Param) : Dynamic {
        try {
            if (param != null && param.value != null && param.value != '') {
                return decodeData(param.value);
            }
        }
        return null;
    }


    private static function loadAllFromFile(): Dynamic {
        final dataFilename = getDataFilename();
        if (FileSystem.exists(dataFilename) && !FileSystem.isDirectory(dataFilename)) {
            return decodeData(File.getContent(dataFilename));
        }
        return null;
    }


    /**
     * Saves data for all requests in Connect.
     * @param request An AssetRequest or TierConfigRequest whose update method will be called.
     * @param data Encoded string with all requests for the given asset or TierConfig.
     * @param param Param to be updated.
     * @param updateFunc The update function to be called (TODO: Get this using reflection).
     * @return Bool Whether the data could be saved in Connect or not.
     */
    private static function saveInConnect(request: IdModel, data: String,
            param: Param, updateFunc: Function) : Bool {
        if (param != null) {
            param.value = data;
            try {
                Reflect.callMethod(request, updateFunc, []);
                return true;
            } catch (ex: Dynamic) {
                Env.getLogger().writeCodeBlock(Logger.LEVEL_ERROR, Std.string(ex), '');
            }
        }
        return false;
    }


    /**
     * Saves data for all requests in the local file.
     * @param data Encoded string with all requests for the given asset or TierConfig.
     * @return Bool Whether the data could be saved in the file or not.
     */
    private static function saveInFile(data: String): Bool {
        final dataFilename = getDataFilename();
        try {
            File.saveContent(dataFilename, data);
            return true;
        } catch (ex: Dynamic) {
            return false;
        }
    }


    private static function getRequestField(object: Dynamic, requestId: String, storage: StorageType): StepData {
        if (Reflect.hasField(object, requestId)) {
            final stepData = Reflect.field(object, requestId);
            return new StepData(stepData.current_step, stepData.data, storage);
        }
        return null;
    }


    private static function getDataFilename(): String {
        final filename = 'step.dat';
        final logPath = Env.getLogger().getPath();
        return (logPath != null)
            ? (logPath + filename)
            : filename;
    }


    private static function encodeData(data: Dynamic): String {
        final bytes = Bytes.ofString(Json.stringify(data));
    #if python
        final compressed = connect.native.PythonZlib.compress(bytes, 9);
    #else
        final compressed = haxe.zip.Compress.run(bytes, 9);
    #end
        return Base64.encode(compressed);
    }


    private static function decodeData(data: String): Dynamic {
        final decoded = Base64.decode(data);
    #if python
        final decompressed = connect.native.PythonZlib.decompress(decoded);
    #else
        final decompressed = haxe.zip.Uncompress.run(decoded);
    #end
        return Json.parse(decompressed.toString());
    }
}
