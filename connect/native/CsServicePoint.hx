package connect.native;


#if cs
@:nativeGen
@:abstract
@:libType
@:csNative
@:native("System.Net.ServicePoint")
extern class CsServicePoint {
    var Expect100Continue: Bool;
}
#end
