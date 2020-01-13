package connect.native;


#if cs
@:nativeGen
@:abstract
@:libType
@:csNative
@:native("System.Net.WebResponse")
extern class CsWebResponse {
    function GetResponseStream(): cs.system.io.Stream;
}
#end
