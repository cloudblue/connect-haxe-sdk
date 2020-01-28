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
@:native("System.Net.WebRequest")
extern class CsWebRequest {
    var ContentLength: cs.StdTypes.Int64;
    var ContentType: String;
    var Headers: CsWebHeaderCollection;
    var Method: String;

    static function Create(requestUriString: String): CsWebRequest;
    function GetRequestStream(): cs.system.io.Stream;
    function GetResponse(): CsWebResponse;
}
#end
