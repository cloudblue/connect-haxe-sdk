/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import connect.Env;


@:dox(hide)
class Util {
    /**
     * Given a list of regex search all in a string and hide this values
     * @param text 
     * @param regExData 
     */
    public static function replaceStrSensitiveData(text:String,regExData:Collection<EReg>):String {
        for (regEx in regExData){
            while(regEx.match(text)){
                text = StringTools.replace(text,regEx.matched(1),StringTools.lpad("","*",9));
            }
        }
        return text;
    }


    /*
        If the text contains a JSON string representation, it returns it beautified using two space
        indentation. Otherwise, returns the string as-is. If `compact` is `true` and the text
        contains a JSON string representation, only the id is returned or a string with all the
        fields if it does not have an id. If `beautify` is `true`, the JSON is returned with
        spacing and indentation.
    */
    public static function beautify(text:String, compact:Bool, masked:Bool, beautify:Bool):String {
        try {
            return beautifyObject(haxe.Json.parse(text), compact, masked, beautify);
        } catch (ex:Dynamic) {
           return replaceStrSensitiveData(text,Env.getLogger().getRegExMaskingList());
        }
    }


    /*
        @returns The JSON representation of the object beautified using two space indentation.
        If `compact` is `true` and the text contains a JSON string representation, only the id
        is returned or a string with all the fields if it does not have an id. If `compact` is
        false and `masked` is true, all fields in the mask list will be masked.
    */
    public static function beautifyObject(obj:Dynamic, compact:Bool, masked:Bool, beautify:Bool):String {
        final spacing = beautify ? '  ' : null;
        if (compact) {
            if (Type.typeof(obj) == TObject) {
                // Json contains an object
                if (Reflect.hasField(obj, 'id')) {
                    return obj.id;
                } else {
                    return '{ ' + Reflect.fields(obj).join(', ') + ' }';
                }
            } else {
                // Json contains an array
                final arr: Array<Dynamic> = obj;
                final mapped = arr.map(function(el) {
                    return Reflect.hasField(el, 'id')
                        ? el.id
                        : (Type.typeof(el) == TObject)
                        ? '{ ' + Reflect.fields(el).join(', ') + ' }'
                        : Std.string(el);
                });
                return haxe.Json.stringify(mapped, null, spacing);
            }
        } else {
            return haxe.Json.stringify(masked ? maskParams(maskFields(obj)) : obj, null, spacing);
        }
    }

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
                } else if (Type.typeof(value) == TObject || Std.is(value, connect.util.Collection) || Std.is(value, Array)) {
                    Reflect.setField(obj, fieldName, maskFields(value));
                }
            }
            return obj;
        } else if (Std.is(obj, Array)) {
            final arr: Array<Dynamic> = obj;
            return arr.map(el -> maskFields(el));
        }
        return obj;
    }


    public static function maskParams(obj:Dynamic):Dynamic {
        if (Type.typeof(obj) == TObject) {
            final maskedParams = Env.getLogger().getMaskedParams();
            for (fieldName in Reflect.fields(obj)) {
                final value = Reflect.field(obj, fieldName);
                if (fieldName == 'params' && Std.is(value, Array)) {
                    for (param in cast(value, Array<Dynamic>)) {
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
                } else if (Type.typeof(value) == TObject || Std.is(value, connect.util.Collection) || Std.is(value, Array)) {
                    Reflect.setField(obj, fieldName, maskParams(value));
                }
            }
        } else if (Std.is(obj, Array)) {
            final arr: Array<Dynamic> = obj;
            return arr.map(el -> maskParams(el));
        }
        return obj;
    }


    /**
        @returns Whether the text seems to contain a JSON object or array.
        NOTE: This function could return `true` even if the JSON string is malformed.
    **/
    public static function isJson(text:String):Bool {
        return isJsonObject(text) || isJsonArray(text);
    }


    /**
        @returns Whether the text seems to contain a JSON object.
        NOTE: This function could return `true` even if the JSON string is malformed.
    **/
    public static function isJsonObject(text:String):Bool {
        return StringTools.trim(text).charAt(0) == '{';
    }


    /**
        @returns Whether the text seems to contain a JSON array.
        NOTE: This function could return `true` even if the JSON string is malformed.
    **/
    public static function isJsonArray(text:String):Bool {
        return StringTools.trim(text).charAt(0) == '[';
    }


    /** @return Whether the passed object is an array. **/
    public static function isArray(value: Dynamic):Bool {
        return Std.is(value, Array);
    }


    /** @return Whether the passed object is a dynamic object. **/
    public static function isStruct(value:Dynamic):Bool {
        return Type.typeof(value) == TObject;
    }


    /**
     * Creates an object with the differences between the two passed objects (except
     * for deletions). The objects must contain an id field.
     * This method is used for example when updating a request, to send only the modified data.
     * @param object The updated object.
     * @param previous The object prior to the updates.
     * @return The object with only the differences.
     */
    public static function createObjectDiff(object:Dynamic, previous:Dynamic):Dynamic {
        return Util.addIdsToObject(
            new diff.Diff(previous, object).apply({id: object.id}),
            previous);
    }


    /**
     * Splits the given text into its lines, detecting Windows (CR+LF), Mac OS Classic (CR) and
     * Unix (LF) line endings.
     * @param text 
     * @return Array<String> 
     */
    public static function getLines(text: String): Array<String> {
        final windowsReplaced = StringTools.replace(Std.string(text), '\r\n', '\n');
        final macosReplaced = StringTools.replace(windowsReplaced, '\r', '\n');
        return macosReplaced.split('\n');
    }


    /**
     * @return Int `1` if the argument is `true`, `0` otherwise.
     */
    public static function boolToInt(b: Bool): Int {
        return b ? 1 : 0;
    }


    /**
     * Creates a new dynamic object that contains the sames fields as `object`.
     * When a field contains a subobject that has no `id` field, but the respective
     * subobject in `original` contains an id field, the value is copied.
     * If a field contains an array, `compactArray` is called on it.
     * This method is used for example when updating a request, to send only the modified data.
     * @return A new dynamic object with the updated data.
     */
    private static function addIdsToObject(object:Dynamic, original:Dynamic):Dynamic {
        final out = {};
        final id = 'id';
        if (!Reflect.hasField(object, id) && Reflect.hasField(original, id)) {
        Reflect.setField(out, id, Reflect.field(original, id));
        }
        Lambda.iter(Reflect.fields(object), function(field) {
        final value = Reflect.field(object, field);
        if (Reflect.hasField(original, field)) {
        final originalValue = Reflect.field(original, field);
        if (isStruct(value) && isStruct(originalValue)) {
        Reflect.setField(out, field, addIdsToObject(value, originalValue));
        } else if (isArray(value) && isArray(originalValue)) {
        final valueArr = cast(value, Array<Dynamic>);
        final originalValueArr = cast(originalValue, Array<Dynamic>);
        Reflect.setField(out, field, compactArray(valueArr, originalValueArr));
        } else {
        Reflect.setField(out, field, value);
        }
        } else {
        Reflect.setField(out, field, value);
        }
        });
        return out;
    }


    /**
     * Creates a new array containing only the non-null elements of `array`.
     * If the value of an element is an array, the method is called recursively.
     * If the value of an element is an object, `addIdsToObject` is called, passing also
     * the value of the same object in the `second` array.
     * @return A new array containing only the modified elements.
     */
    private static function compactArray(array:Array<Dynamic>, second:Array<Dynamic>)
    :Array<Dynamic> {
        final out: Array<Dynamic>= [];
        for (i in 0...array.length) {
        final value = array[i];
        final secondValue = second[i];
        if (isStruct(value) && isStruct(secondValue)) {
        out.push(addIdsToObject(value, secondValue));
        } else if (isArray(value) && isArray(secondValue)) {
        final valueArr = cast(value, Array<Dynamic>);
        final secondValueArr = cast(secondValue, Array<Dynamic>);
        out.push(compactArray(valueArr, secondValueArr));
        } else if (value != null) {
        out.push(value);
        }
        }
        return out;
    }
}
