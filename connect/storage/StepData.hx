/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.storage;

import connect.models.Model;
import connect.util.Dictionary;
import haxe.Json;

@:dox(hide)
enum StorageType {
    ConnectStorage;
    LocalStorage;
    FailedStorage;
}

@:dox(hide)
class StepData {
    public final firstIndex: Int;
    public final data: Dictionary;
    public final storage: StorageType;
    public final attempt: Null<Int>;

    public function new(firstIndex: Int, data: Dynamic, storage: StorageType, attempt:Int) {
        this.firstIndex = firstIndex;
        this.data = (Std.is(data, Dictionary))
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
                Std.is(value, Model) ? Type.getClassName(Type.getClass(value)) :
                Std.is(value, Dictionary) ? 'Dictionary' :
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
}
