/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;


/**
    This class adds functional operations missing in Haxe's Lambda class.
**/
@:dox(hide)
class F {
    public static function reduce<A, B>(it: Iterable<A>, f: (B, A, Int, Iterable<A>) -> B, initialValue: B): B {
        var value = initialValue;
        var i = 0;
        for (elem in it) {
            value = f(value, elem, i, it);
            ++i;
        }
        return value;
    }
}
