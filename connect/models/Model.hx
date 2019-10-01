package connect.models;

import connect.Util;
import haxe.ds.StringMap;


class Model {
    private var fieldClassNames(default, null): StringMap<String>;


    public function toObject(): Dynamic {
        var obj = {};
        var fields = Type.getInstanceFields(Type.getClass(this));
        for (field in fields) {
            var value = Reflect.getProperty(this, field);
            if (field != 'fieldClassNames' && value != null) {
                switch (Type.typeof(value)) {
                    case TClass(String):
                        if (value.toString() != '') {
                            Reflect.setField(obj, Inflection.toSnakeCase(field), value.toString());
                        }
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


    public function toDictionary(): Dictionary {
        return Util.jsonToCollectionOrDictionary(this.toObject());
    }


    public function toString(): String {
        return haxe.Json.stringify(this.toObject());
    }


    public function getFieldClassName(field: String): String {
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


    public static function parse<T>(modelClass: Class<T>, obj: Dictionary): T {
        var model = Type.createInstance(modelClass, []);
        var castedModel = cast(model, Model);
        var fields = Type.getInstanceFields(modelClass);
        for (field in fields) {
            var snakeField = Inflection.toSnakeCase(field);
            if (obj.exists(snakeField)) {
                var val = obj.get(snakeField);
                //trace('Injecting "${field}" in ' + Type.getClassName(modelClass));
                switch (Type.typeof(val)) {
                    case TClass(Collection):
                        var className = castedModel.getFieldClassName(field);
                        if (className == null) {
                            var camelField = 'connect.models.' + Inflection.toCamelCase(field, true);
                            className = Inflection.toSingular(camelField);
                        }
                        var classObj = Type.resolveClass(className);
                        Reflect.setProperty(model, field, parseCollection(classObj, val));
                    case TClass(Dictionary):
                        var className = castedModel.getFieldClassName(field);
                        if (className == null) {
                            className = 'connect.models.' + Inflection.toCamelCase(field, true);
                        }
                        var classObj = Type.resolveClass(className);
                        if (classObj != null) {
                            Reflect.setProperty(model, field, parse(classObj, val));
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


    public static function parseCollection<T>(modelClass: Class<T>,
            collection: Collection<Dictionary>): Collection<T> {
        var result = new Collection<T>();
        for (dict in collection) {
            result.push(parse(modelClass, dict));
        }
        return result;
    }


    public function _setFieldClassNames(map: StringMap<String>): Void {
        if (this.fieldClassNames == null) {
            this.fieldClassNames = map;
        }
    }
}
