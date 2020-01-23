package connect.native;


#if cs
@:nativeGen
@:abstract
@:libType
@:csNative
@:native("System.Net.HttpWebRequest")
extern class CsHttpWebRequest extends CsWebRequest {
    final ServicePoint: CsServicePoint;

    static function Create(requestUriString: String): CsWebRequest;
}
#end
