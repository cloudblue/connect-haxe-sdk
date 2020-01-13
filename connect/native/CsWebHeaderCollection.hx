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
