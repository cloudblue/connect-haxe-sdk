package connect;


@:dox(hide)
class Util {
    public static function getDate(?dateOrNull: Date): String {
        final date = (dateOrNull != null) ? dateOrNull : Date.now();
        return new Date(
            date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(),
            date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()
        ).toString();
    }


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
        NOTE: If the JSON string is malformed, this still returns `true`.
    **/
    public static function isJson(text: String): Bool {
        return isJsonObject(text) || isJsonArray(text);
    }


    /**
        @returns Whether the text seems to contain a JSON object.
        NOTE: If the JSON string is malformed, this still returns `true`.
    **/
    public static function isJsonObject(text: String): Bool {
        return StringTools.trim(text).charAt(0) == '{';
    }


    /**
        @returns Whether the text seems to contain a JSON array.
        NOTE: If the JSON string is malformed, this still returns `true`.
    **/
    public static function isJsonArray(text: String): Bool {
        return StringTools.trim(text).charAt(0) == '[';
    }


    /**
     * Updates the object on the left with the data in the object on the right
     * @return Dynamic The updated object
     */
    public static function updateObject(left: Dynamic, right: Dynamic): Dynamic {
        final out = Reflect.copy(left);
        Lambda.iter(Reflect.fields(right), function(field) {
            final value = Reflect.field(right, field);
            if (!Reflect.hasField(out, field)) {
                Reflect.setField(out, field, value);
            } else {
                if (isStruct(value)) {
                    final leftObject = Reflect.field(left, field);
                    Reflect.setField(out, field, updateObject(leftObject, field));
                } else if (isArray(value)) {
                    final leftArray = Reflect.field(left, field);
                    Reflect.setField(out, field, updateArray(leftArray, value));
                } else {
                    Reflect.setField(out, field, value);
                }
            }
        });
        return out;
    }


    /**
     * Updates the array on the left with the data in the array on the right. If the
     * value on the right is null, the value on the left is left as it was.
     * @return Dynamic The updated object
     */
    public static function updateArray(left: Array<Dynamic>, right: Array<Dynamic>)
            : Array<Dynamic> {
        final out = Reflect.copy(left);

        //return out;
    }


    public static function isArray(v: Dynamic): Bool {
        return Std.is(v, Array);
    }


    public static function isStruct(v: Dynamic): Bool {
        return Type.typeof(v) == TObject;
    }
}
