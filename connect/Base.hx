package connect;

import python.Syntax;


@:dox(hide)
class Base {
#if python
    private function __getattr__(key: String): Dynamic {
        var class_ = Type.getClass(this);
        var fields = Type.getInstanceFields(class_);
        var camelized = Inflection.toCamelCase(key);
        if (fields.indexOf(camelized) > -1) {
            return python.lib.Builtins.getattr(this, camelized);
        } else {
            var className = Type.getClassName(class_);
            throw new python.Exceptions.AttributeError('\'${className}\' object has no attribute \'${key}\'');
        }
    }


    private function __setattr__(key: String, value: Dynamic): Dynamic {
        var class_ = Type.getClass(this);
        var fields = Type.getInstanceFields(class_);
        var camelized = Inflection.toCamelCase(key);
        if (fields.indexOf(key) == -1 && fields.indexOf(camelized) > -1) {
            key = camelized;
        }
        return python.Syntax.code("super().__setattr__({0}, {1})", key, value);
    }
#end
}
