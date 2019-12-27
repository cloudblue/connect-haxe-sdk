/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;


@:dox(hide)
class Util {
    /*
        If the text contains a JSON string representation, it returns it beautified using two space
        indentation. Otherwise, returns the string as-is. If `compact` is `true` and the text
        contains a JSON string representation, only the id is returned or a string with all the
        fields if it does not have an id.
    */
    public static function beautify(text: String, compact: Bool): String {
        try {
            return beautifyObject(haxe.Json.parse(text), compact);
        } catch (ex: Dynamic) {
            return text;
        }
    }


    /*
        @returns The JSON representation of the object beautified using two space indentation.
        If `compact` is `true` and the text contains a JSON string representation, only the id
        is returned or a string with all the fields if it does not have an id.
    */
    public static function beautifyObject(obj: Dynamic, compact: Bool): String {
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
            return haxe.Json.stringify(obj, null, '  ');
        }
    }


    /**
        @returns Whether the text seems to contain a JSON object or array.
        NOTE: This function could return `true` even if the JSON string is malformed.
    **/
    public static function isJson(text: String): Bool {
        return isJsonObject(text) || isJsonArray(text);
    }


    /**
        @returns Whether the text seems to contain a JSON object.
        NOTE: This function could return `true` even if the JSON string is malformed.
    **/
    public static function isJsonObject(text: String): Bool {
        return StringTools.trim(text).charAt(0) == '{';
    }


    /**
        @returns Whether the text seems to contain a JSON array.
        NOTE: This function could return `true` even if the JSON string is malformed.
    **/
    public static function isJsonArray(text: String): Bool {
        return StringTools.trim(text).charAt(0) == '[';
    }


    /**
     * Creates an object with the differences between the two passed objects (except
     * for deletions). The objects must contain an id field.
     * @param object The updated object.
     * @param previous The object prior to the updates.
     * This method is used for example when updating a request, to send only the modified data.
     * @return The object with only the differences.
     */
    public static function createObjectDiff(object: Dynamic, previous: Dynamic): Dynamic {
        return Util.addIdsToObject(
            new Diff(previous, object).apply({id: object.id}),
            previous);
    }


    public static function isArray(value: Dynamic): Bool {
        return Std.is(value, Array);
    }


    public static function isStruct(value: Dynamic): Bool {
        return Type.typeof(value) == TObject;
    }


    /**
     * Creates a new dynamic object that contains the sames fields as `object`.
     * When a field contains a subobject that has no `id` field, but the respective
     * subobject in `original` contains an id field, the value is copied.
     * If a field contains an array, `compactArray` is called on it.
     * This method is used for example when updating a request, to send only the modified data.
     * @return A new dynamic object with the updated data.
     */
    private static function addIdsToObject(object: Dynamic, original: Dynamic): Dynamic {
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
                    Reflect.setField(out, field, compactArray(value, originalValue));
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
    private static function compactArray(array: Array<Dynamic>, second: Array<Dynamic>)
            : Array<Dynamic> {
        final out = [];
        for (i in 0...array.length) {
            final value = array[i];
            final secondValue = second[i];
            if (isStruct(value) && isStruct(secondValue)) {
                out.push(addIdsToObject(value, secondValue));
            } else if (isArray(value) && isArray(secondValue)) {
                out.push(compactArray(value, secondValue));
            } else if (value != null) {
                out.push(value);
            }
        }
        return out;
    }
}
