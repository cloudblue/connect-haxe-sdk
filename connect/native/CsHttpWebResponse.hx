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
