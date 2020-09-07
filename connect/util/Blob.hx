/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import haxe.io.Bytes;
import haxe.io.UInt8Array;


/**
    This object represents a buffer of binary data. Just as the contents of a text file can be
    represented by a string, the contents of binary files can be represented by a Blob.
**/
class Blob extends Base {
    /** Loads the contents of the file at the specified path as a Blob object. **/
    public static function load(path: String): Blob {
        try {
            return new Blob(sys.io.File.getBytes(path));
        } catch (ex: Dynamic) {
            return new Blob(null);
        }
    }


    /** Saves the blob to the specified `path`. **/
    public function save(path: String): Void {
        sys.io.File.saveBytes(path, this.bytes);
    }


    /** @returns The number of bytes contained in the object. **/
    public function length(): Int {
        return (bytes != null) ? bytes.length : -1;
    }


    /** @returns A String representation of the data interpreted as UTF-8. **/
    public function toString(): String {
        return (bytes != null) ? bytes.toString() : '';
    }


    @:dox(hide)
    public static function _fromBytes(bytes: Bytes): Blob {
        return new Blob(bytes);
    }
    
    
    @:dox(hide)
    public function _getBytes(): Bytes {
        return bytes;
    }


    @:dox(hide)
    public function _toArray(): Array<Int> {
        return _bytesToArray(_getBytes());
    }


    @:dox(hide)
    public static function _bytesToArray(bytes: Bytes): Array<Int> {
        return (bytes != null) ? [for (b in UInt8Array.fromBytes(bytes)) b] : null;
    }


    private final bytes: Bytes;


    private function new(bytes: Bytes) {
        this.bytes = bytes;
    }
}
