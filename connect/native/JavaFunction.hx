/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.native;


#if javalib
@:nativeGen
@:abstract
@:javaNative
@:native("java.util.function.Function")
@:javaCanonical("java.util.function","Function")
interface JavaFunction<T, R> {
    @:overload
    function apply(param: T): R;
}
#end
