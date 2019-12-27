/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.native;


#if java
@:nativeGen
@:abstract
@:javaNative
@:native("java.util.function.Consumer")
@:javaCanonical("java.util.function","Consumer")
interface JavaConsumer<T> {
    @:overload
    function accept(param: T): Void;
}
#end
