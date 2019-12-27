/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;

import python.Syntax;


@:dox(hide)
class Base {
#if python
    private function __getattr__(key: String): Dynamic {
        final class_ = Type.getClass(this);
        final fields = Type.getInstanceFields(class_);
        final camelized = Inflection.toCamelCase(key);
        if (fields.indexOf(camelized) > -1) {
            return python.lib.Builtins.getattr(this, camelized);
        } else {
            final className = Type.getClassName(class_);
            throw new python.Exceptions.AttributeError('\'${className}\' object has no attribute \'${key}\'');
        }
    }


    private function __setattr__(key: String, value: Dynamic): Dynamic {
        final class_ = Type.getClass(this);
        final fields = Type.getInstanceFields(class_);
        final camelized = Inflection.toCamelCase(key);
        if (fields.indexOf(key) == -1 && fields.indexOf(camelized) > -1) {
            key = camelized;
        }
        return python.Syntax.code("super().__setattr__({0}, {1})", key, value);
    }


    private function __eq__(other: Dynamic): Bool {
        final thisType = Syntax.code("type({0})", this);
        final otherType = Syntax.code("type({0})", other);
        return thisType == otherType && Std.string(this) == Std.string(other);
    }
#end
}
