package connect.native;


#if cs
@:nativeGen
@:abstract
@:libType
@:csNative
@:native("System.Net.WebRequest")
extern class CsWebRequest {
    var ContentType: String;
    var Headers: CsWebHeaderCollection;

    static function Create(requestUriString: String): CsWebRequest;
    function GetResponse(): CsWebResponse;
}
#end
