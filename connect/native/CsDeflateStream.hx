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
@:native("System.IO.Compression.DeflateStream")
extern class CsDeflateStream extends cs.system.io.Stream {
    function new(stream: cs.system.io.Stream, mode: Int);
}
#end
