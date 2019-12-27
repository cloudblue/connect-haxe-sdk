/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.Inflection;
import haxe.ds.StringMap;
import haxe.Json;


/**
    Base model class.
**/
class Model extends Base {
    /** @returns A Haxe dynamic object with a shallow copy of `this` model's properties. **/
    public function toObject(): Dynamic {
        final obj = {};
        final fields = Type.getInstanceFields(Type.getClass(this));
        for (field in fields) {
            final value = Reflect.field(this, field);
            if (field != 'fieldClassNames' && value != null) {
                switch (Type.typeof(value)) {
                    case TClass(String):
                        Reflect.setField(obj, Inflection.toSnakeCase(field), Std.string(value));
                    case TClass(connect.DateTime):
                        Reflect.setField(obj, Inflection.toSnakeCase(field), value.toString());
                    case TClass(class_):
                        final className = Type.getClassName(class_);
                        if (className.indexOf('connect.Collection') == 0) {
                            final col = cast(value, Collection<Dynamic>);
                            final arr = new Array<Dynamic>();
                            for (elem in col) {
                                final elemClassName = Type.getClassName(Type.getClass(elem));
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
                            final model = cast(value, Model).toObject();
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
        return Json.stringify(this.toObject());
    }


    /**
        Parses the given string-encoded Json as a Model of the specified class.

        @returns The parsel model.
        @throws String If `obj` is not a dynamic object or if the class for a field was not
            found.
    **/
    public static function parse<T>(modelClass: Class<T>, body: String): T {
        final obj = Json.parse(body);
        if (Std.is(obj, Array)) {
            throw 'Model.parse cannot parse a Json that contains an array.';
        }
        return _parse(modelClass, obj);
    }


    /** Parses the given Haxe dynamic object as a Collection of Models of the specified class. **/
    public static function parseArray<T>(modelClass: Class<T>, body: String): Collection<T> {
        final array: Array<Dynamic> = Json.parse(body);
        if (!Std.is(array, Array)) {
            throw 'Model.parseArray can only parse a Json that contains an array.';
        }
        return _parseArray(modelClass, array);
    }


    @:dox(hide)
    public function _setFieldClassNames(map: StringMap<String>): Void {
        if (this.fieldClassNames == null) {
            this.fieldClassNames = map;
        }
    }


    public function new() {}


    private var fieldClassNames: StringMap<String>;


    private static function _parse<T>(modelClass: Class<T>, obj: Dynamic): T {
        final instance = Type.createInstance(modelClass, []);
        final model = cast(instance, Model);
        for (field in Type.getInstanceFields(modelClass)) {
            final snakeField = Inflection.toSnakeCase(field);
            final camelField = Inflection.toCamelCase(field, true);
            if (Reflect.hasField(obj, snakeField)) {
                final val: Dynamic = Reflect.field(obj, snakeField);
                //trace('Injecting "${field}" in ' + Type.getClassName(modelClass));
                switch (Type.typeof(val)) {
                    case TClass(Array):
                        final fieldClassName = model.getFieldClassName(field);
                        final className = (fieldClassName == null)
                            ? Inflection.toSingular('connect.models.' + camelField)
                            : fieldClassName;
                        final classObj = Type.resolveClass(className);
                        Reflect.setProperty(model, field, _parseArray(classObj, val));
                    case TObject:
                        final fieldClassName = model.getFieldClassName(field);
                        final className = (fieldClassName == null)
                            ? 'connect.models.' + camelField
                            : fieldClassName;
                        final classObj = Type.resolveClass(className);
                        if (classObj != null) {
                            if (className != 'String') {
                                Reflect.setProperty(model, field, _parse(classObj, val));
                            } else {
                                Reflect.setProperty(model, field, Json.stringify(val));
                            }
                        } else {
                            throw 'Cannot find class "$className"';
                        }
                    default:
                        final fieldClassName = model.getFieldClassName(field);
                        if (fieldClassName == 'DateTime') {
                            Reflect.setProperty(model, field, DateTime.fromString(val));
                        } else {
                            try {
                                Reflect.setProperty(model, field, val);
                            } catch (ex: Dynamic) {
                                // It will fail if we are trying to set a protected property
                                // (like __getattr__ or __setattr__ on Python)
                            }
                        }
                }
            }
        }
        return instance;
    }


    private static function _parseArray<T>(modelClass: Class<T>, array: Array<Dynamic>): Collection<T> {
        final result = new Collection<T>();
        for (obj in array) {
            if (modelClass != null) {
                result.push(_parse(modelClass, obj));
            } else {
                result.push(obj);
            }
        }
        return result;
    }


    private function getFieldClassName(field: String): String {
        if (this.fieldClassNames != null && this.fieldClassNames.exists(field)) {
            final nameInField: String = this.fieldClassNames.get(field);
            final exceptions = ['DateTime', 'String'];
            return (exceptions.indexOf(nameInField) == -1)
                ? 'connect.models.' + nameInField
                : nameInField;
        } else {
            return null;
        }
    }
}
