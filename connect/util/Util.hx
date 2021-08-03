/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import connect.Env;

@:dox(hide)
class Util {
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
        return Std.isOfType(value, Array);
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
            new Diff(previous, object).apply({id: object.id}),
            previous);
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
        for (field in Reflect.fields(object)) {
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
        }
        return out;
    }

    /**
     * Creates a new array containing only the non-null elements of `array`.
     * If the value of an element is an array, the method is called recursively.
     * If the value of an element is an object, `addIdsToObject` is called, passing also
     * the value of the same object in the `second` array.
     * @return A new array containing only the modified elements.
     */
     private static function compactArray(array:Array<Dynamic>, second:Array<Dynamic>):Array<Dynamic> {
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

    /** Returns a regular expression from the given string. **/
    public static function toRegEx(expression:String):EReg {
        expression = StringTools.startsWith(expression, "(") ? expression : "(" + expression;
        expression = StringTools.endsWith(expression, ")") ? expression : expression + ")";
        return new EReg(expression, "g");
    }
}
