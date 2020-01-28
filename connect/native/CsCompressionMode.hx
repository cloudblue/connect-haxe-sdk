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
@:native("System.IO.Compression.CompressionMode")
extern class CsCompressionMode {
    public static final Compress: Int;
    public static final Decompress: Int;
}
#end
