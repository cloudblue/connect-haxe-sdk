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
@:native("System.Net.HttpWebResponse")
extern class CsHttpWebResponse extends CsWebResponse {
    var StatusCode(default, null): Int;
}
#end
