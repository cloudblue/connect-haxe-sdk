/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.native;


#if cs
@:nativeGen
@:abstract
@:libType
@:csNative
@:native("System.Net.WebHeaderCollection")
extern class CsWebHeaderCollection {
    function new();
    function Add(name: String, value: String): Void;
}
#end
