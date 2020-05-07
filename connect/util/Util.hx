/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import connect.Env;
import connect.logger.Logger;


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
        fields if it does not have an id.
    */
    public static function beautify(text:String, compact:Bool, masked: Bool):String {
        try {
            return beautifyObject(haxe.Json.parse(text), compact, masked);
        } catch (ex:Dynamic) {
           return replaceStrSensitiveData(text,Env.getLogger().getRegExMaskingList());
        }
    }


    /*
        @returns The JSON representation of the object beautified using two space indentation.
        If `compact` is `true` and the text contains a JSON string representation, only the id
        is returned or a string with all the fields if it does not have an id.
    */
    public static function beautifyObject(obj:Dynamic, compact:Bool, masked:Bool):String {
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
                return haxe.Json.stringify(mapped, null, '  ');
            }
        } else {
            return haxe.Json.stringify(masked ? maskFields(obj) : obj, null, '  ');
        }
    }

    public static function maskFields(obj:Dynamic): Dynamic {
        final  maskedFields= Env.getLogger().getMaskedFields();
        if (Type.typeof(obj) == TObject) {
            for(fieldName in Reflect.fields(obj)){
                if(maskedFields.indexOf(fieldName) !=  - 1){
                    if (Type.typeof(Reflect.field(obj, fieldName)) == TObject){
                        if (Reflect.hasField(Reflect.field(obj, fieldName), 'id')) {
                            Reflect.setField(obj, fieldName, Reflect.field(obj, fieldName).id);
                        } else {
                            Reflect.setField(obj, fieldName, '{object}');
                        }
                    }else{
                        Reflect.setField(obj, fieldName, 'HIDDEN FIELD');
                    }
                }else if (Type.typeof(obj) == TObject || Std.is(obj,connect.util.Collection) ||  Std.is(obj, Array)){
                    Reflect.setField(obj, fieldName, maskFields(Reflect.field(obj, fieldName)));
                }
            }
            return obj;
        }else if (Std.is(obj, Array)){
            final arr: Array<Dynamic> = obj;
            return arr.map(function(el) {
                return maskFields(el);
            });
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
