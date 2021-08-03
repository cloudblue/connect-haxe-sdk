/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import connect.Env;

@:dox(hide)
class Masker {
    /** @returns The string with masking applied. **/
    public static function maskString(text:String):String {
        try {
            return maskObject(haxe.Json.parse(text));
        } catch (ex:Dynamic) {
            return replaceStrSensitiveData(text, Env.getLogger()._getRegExMaskingList());
        }
    }

    /** @returns The string representation of the object with masking applied. **/
    public static function maskObject(obj:Dynamic):String {
        // TODO: Shouldn't replaceStrSensitiveData be called on the string? Ask Adrian why regex is not being masked here.
        return haxe.Json.stringify(maskParams(maskFields(obj)));
    }

    /** @returns A copy of the object with masking of fields applied. **/
    public static function maskFields(obj:Dynamic):Dynamic {
        if (Type.typeof(obj) == TObject) {
            final maskedFields = Env.getLogger().getMaskedFields();
            for (fieldName in Reflect.fields(obj)) {
                final value = Reflect.field(obj, fieldName);
                if (maskedFields.indexOf(fieldName) != -1) {
                    if (Type.typeof(value) == TObject){
                        if (Reflect.hasField(value, 'id')) {
                            Reflect.setField(obj, fieldName, value.id);
                        } else {
                            Reflect.setField(obj, fieldName, '{object}');
                        }
                    } else {
                        Reflect.setField(obj, fieldName, StringTools.lpad('', '*', value.length));
                    }
                } else if (Type.typeof(value) == TObject || Std.isOfType(value, Collection) || Std.isOfType(value, Array)) {
                    Reflect.setField(obj, fieldName, maskFields(value));
                }
            }
            return obj;
        } else if (Std.isOfType(obj, Array)) {
            final arr: Array<Dynamic> = obj;
            return arr.map(el -> maskFields(el));
        }
        return obj;
    }

    private static function maskParams(obj:Dynamic):Dynamic {
        if (Type.typeof(obj) == TObject) {
            maskParamsInObject(obj);
        } else if (Std.isOfType(obj, Array)) {
            return cast(obj, Array<Dynamic>).map(el -> maskParams(el));
        }
        return obj;
    }

    private static function maskParamsInObject(obj:Dynamic):Void {
        final maskedParams = Env.getLogger().getMaskedParams();
        if (maskedParams.length() > 0) {
            final hasParameterField = Reflect.hasField(obj, 'parameter');
            for (fieldName in Reflect.fields(obj)) {
                final value: Dynamic = Reflect.field(obj, fieldName);
                if (fieldName == 'params' && Std.isOfType(value, Array)) {
                    maskParamsArray(value, maskedParams);
                } else if (fieldName == 'value' && hasParameterField) {
                    maskConfigParam(obj, Reflect.field(obj, 'parameter'), maskedParams);
                } else if (Type.typeof(value) == TObject || Std.isOfType(value, Collection) || Std.isOfType(value, Array)) {
                    Reflect.setField(obj, fieldName, maskParams(value));
                }
            }
        }
    }

    private static function maskParamsArray(arr: Array<Dynamic>, maskedParams: Collection<String>):Void {
        for (param in arr) {
            if (Type.typeof(param) == TObject && Reflect.hasField(param, 'id') && Reflect.hasField(param, 'value')) {
                final isPassword = Reflect.hasField(param, 'type')
                    ? (Reflect.field(param, 'type') == 'password')
                    : false;
                if (maskedParams.indexOf(Std.string(Reflect.field(param, 'id'))) != -1 || isPassword) {
                    final paramValue = Std.string(Reflect.field(param, 'value'));
                    Reflect.setField(param, 'value', StringTools.lpad('', '*', paramValue.length));
                }
            }
        }
    }

    private static function maskConfigParam(obj:Dynamic, configParam: Dynamic, maskedParams: Collection<String>):Void {
        if (Type.typeof(configParam) == TObject && Reflect.hasField(configParam, 'id')) {
            final isPassword = Reflect.hasField(configParam, 'type')
                ? (Reflect.field(configParam, 'type') == 'password')
                : false;
            if (maskedParams.indexOf(Std.string(Reflect.field(configParam, 'id'))) != -1 || isPassword) {
                final paramValue = Std.string(Reflect.field(obj, 'value'));
                Reflect.setField(obj, 'value', StringTools.lpad('', '*', paramValue.length));
                if (Reflect.hasField(configParam, 'value')) {
                    final paramValue = Std.string(Reflect.field(configParam, 'value'));
                    Reflect.setField(configParam, 'value', StringTools.lpad('', '*', paramValue.length));
                }
            }
        }
    }

    private static function replaceStrSensitiveData(text:String, regExData:Collection<EReg>):String {
        for (regEx in regExData) {
            while (regEx.match(text)) {
                text = StringTools.replace(text, regEx.matched(1), StringTools.lpad("","*",9));
            }
        }
        return text;
    }
}
