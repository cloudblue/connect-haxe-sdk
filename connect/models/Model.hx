package connect.models;

import connect.Inflection;
import haxe.ds.StringMap;


/**
    Base model class.
**/
class Model {
    private var fieldClassNames(default, null): StringMap<String>;


    /** @returns A Haxe dynamic object with a shallow copy of `this` model's properties. **/
    public function toObject(): Dynamic {
        var obj = {};
        var fields = Type.getInstanceFields(Type.getClass(this));
        for (field in fields) {
            var value = Reflect.getProperty(this, field);
            if (field != 'fieldClassNames' && value != null) {
                switch (Type.typeof(value)) {
                    case TClass(String):
                        Reflect.setField(obj, Inflection.toSnakeCase(field), Std.string(value));
                    case TClass(class_):
                        var className = Type.getClassName(class_);
                        if (className.indexOf('connect.Collection') == 0) {
                            var col = cast(value, Collection<Dynamic>);
                            var arr = new Array<Dynamic>();
                            for (elem in col) {
                                var elemClassName = Type.getClassName(Type.getClass(elem));
                                if (elemClassName.indexOf('connect.models.') == 0) {
                                    arr.push(elem.toObject());
                                } else {
                                    arr.push(elem);
                                }                                
                            }
                            if (arr.length > 0) {
                                Reflect.setField(obj, Inflection.toSnakeCase(field), arr);
                            }
                        } else if (className.indexOf('connect.models.') == 0) {
                            var model = cast(value, Model).toObject();
                            if (Reflect.fields(model).length != 0) {
                                Reflect.setField(obj, Inflection.toSnakeCase(field), model);
                            }
                        } else {
                            Reflect.setField(obj, Inflection.toSnakeCase(field), value);
                        }
                    case TFunction:
                        // Skip
                    default:
                        Reflect.setField(obj, Inflection.toSnakeCase(field), value);
                }
            }
        }
        return obj;
    }


    /** @returns A String with the JSON representation of `this` Model. **/
    public function toString(): String {
        return haxe.Json.stringify(this.toObject());
    }


    /**
        Parses the given Haxe dynamic object as a Model of the specified class.

        @returns The parsel model.
        @throws String If `obj` is not a dynamic object or if the class for a field was not
            found.
    **/
    public static function parse<T>(modelClass: Class<T>, obj: Dynamic): T {
        if (Type.typeof(obj) != TObject) {
            throw 'Model.parse should receive a dynamic object, not a ${Type.typeof(obj)}';
        }
        var model = Type.createInstance(modelClass, []);
        var castedModel = cast(model, Model);
        var fields = Type.getInstanceFields(modelClass);
        for (field in fields) {
            var snakeField = Inflection.toSnakeCase(field);
            if (Reflect.hasField(obj, snakeField)) {
                var val: Dynamic = Reflect.field(obj, snakeField);
                //trace('Injecting "${field}" in ' + Type.getClassName(modelClass));
                switch (Type.typeof(val)) {
                    case TClass(Array):
                        var className = castedModel._getFieldClassName(field);
                        if (className == null) {
                            var camelField = 'connect.models.' + Inflection.toCamelCase(field, true);
                            className = Inflection.toSingular(camelField);
                        }
                        var classObj = Type.resolveClass(className);
                        Reflect.setProperty(model, field, parseArray(classObj, val));
                    case TObject:
                        var className = castedModel._getFieldClassName(field);
                        if (className == null) {
                            className = 'connect.models.' + Inflection.toCamelCase(field, true);
                        }
                        var classObj = Type.resolveClass(className);
                        if (classObj != null) {
                            if (className != 'String') {
                                Reflect.setProperty(model, field, parse(classObj, val));
                            } else {
                                Reflect.setProperty(model, field, haxe.Json.stringify(val));
                            }
                        } else {
                            throw 'Cannot find class "${className}"';
                        }
                    default:
                        Reflect.setProperty(model, field, val);
                }
            }
        }
        return model;
    }


    /** Parses the given Haxe dynamic object as a Collection of Models of the specified class. **/
    public static function parseArray<T>(modelClass: Class<T>, array: Array<Dynamic>): Collection<T> {
        var result = new Collection<T>();
        for (obj in array) {
            result.push(parse(modelClass, obj));
        }
        return result;
    }


    @:dox(hide)
    public function _setFieldClassNames(map: StringMap<String>): Void {
        if (this.fieldClassNames == null) {
            this.fieldClassNames = map;
        }
    }


    @:dox(hide)
    public function _getFieldClassName(field: String): String {
        if (this.fieldClassNames != null && this.fieldClassNames.exists(field)) {
            var className = this.fieldClassNames.get(field);
            var exceptions = ['String'];
            if (exceptions.indexOf(className) == -1) {
                className = 'connect.models.' + className;
            }
            return className;
        } else {
            return null;
        }
    }


    public function new() {}
}
