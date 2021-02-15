/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.storage;

import connect.models.Model;
import connect.util.Dictionary;
import haxe.Json;

/** Indicates how a `StepData` is stored. **/
@:dox(hide)
enum StorageType {
    /** StepData saved in Connect. **/
    ConnectStorage;

    /** StepData saved in a local file. **/
    LocalStorage;

    /** StepData failed to load. **/
    FailedStorage;
}

/** The data of a `connect.Flow` step. It can be saved and retrieved later to resume execution of the flow. **/
@:dox(hide)
class StepData {
    /** Index of the step. **/
    public final firstIndex: Int;

    /** `connect.Flow` data when the step was last executed. **/
    public final data: Dictionary;

    /** How this step was stored: `ConnectStorage`, `LocalStorage`, `FailedStorage`. **/
    public final storage: StorageType;

    /** Number of attempts that this step has tried to run. **/
    public final attempt: Null<Int>;

    /**
        Created a StepData with the passed attributes. The `data` can be of one of these types:

        - `connect.util.Dictionary`: Passed when `this` `StepData` is to be stored.
          The dictionary will be copied recursively, and all keys will contain a suffix with the
          class name of the corresponding value, so it can be used in deserialization.
        - `Dynamic` object: Passed when `this` `StepData` is to be retrieved from file. A new
          dictionary will be created with the contents of the objects, deserializing the values
          based on the type indicated on the key suffixes. These suffixes will be removed.
    **/
    public function new(firstIndex: Int, data: Dynamic, storage: StorageType, attempt:Null<Int>) {
        this.firstIndex = firstIndex;
        this.data = (Std.isOfType(data, Dictionary))
            ? createDictionaryWithClassnameSuffixes(data)
            : createDictionaryAndDeserializeContent(data);
        this.storage = storage;
        this.attempt = attempt;
    }

    private static function createDictionaryWithClassnameSuffixes(dict: Dictionary): Dictionary {
        final data = new Dictionary();
        for (key in dict.keys()) {
            final value: Dynamic = dict.get(key);
            final className =
                Std.isOfType(value, Model) ? Type.getClassName(Type.getClass(value)) :
                Std.isOfType(value, Dictionary) ? 'Dictionary' :
                '';
            final fixedValue: Dynamic = (className == 'Dictionary')
                ? createDictionaryWithClassnameSuffixes(value)
                : value;
            data.set('$key::$className', fixedValue);
        }
        return data;
    }

    private static function createDictionaryAndDeserializeContent(obj: Dynamic): Dictionary {
        final data = new Dictionary();
        for (field in Reflect.fields(obj)) {
            final fieldSplit = field.split('::');
            final fieldName = fieldSplit.slice(0, -1).join('::');
            final fieldClassName = fieldSplit.slice(-1)[0];
            final fieldClass =
                (fieldClassName == 'Dictionary') ? Dictionary :
                (fieldClassName != '') ? Type.resolveClass(fieldClassName) :
                null;
            final value = Reflect.field(obj, field);
            final parsedValue: Dynamic =
                (fieldClass == Dictionary) ? createDictionaryAndDeserializeContent(value) :
                (fieldClass != null) ? Model.parse(fieldClass, Json.stringify(value)) :
                value;
            data.set(fieldName, parsedValue);
        }
        return data;
    }

    public function toString(): String {
        final dynObj:Dynamic = {
            current_step: this.firstIndex,
            data: this.data.toObject()
        };
        if (this.attempt != null) {
            Reflect.setField(dynObj, 'attempt', this.attempt);
        }
        return Json.stringify(dynObj);
    }
}
