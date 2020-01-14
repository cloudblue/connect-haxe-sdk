/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.native;


#if cslib
@:nativeGen
@:abstract
@:libType
@:csNative
@:native("System.Func")
extern class CsFunc<T, R> {
    @:overload
    function Invoke(obj: T): R;
}
#end
