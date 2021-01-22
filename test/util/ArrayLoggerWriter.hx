/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package test.util;


import connect.logger.ILoggerWriter;
import connect.Base;
@:dox(hide)
class ArrayLoggerWriter extends Base implements ILoggerWriter {
    public function new() {
        this.filename = null;
        this.file = null;
    }


    public function setFilename(filename: String): Bool {
        final currentFilename = this.filename;
        this.filename = filename;
        if (filename != currentFilename && this.file != null) {
            this.file.close();
            this.file = null;
            return true;
        } else {
            return false;
        }
    }


    public function getFilename(): String {
        return this.filename;
    }


    public function writeLine(line: String): Void {
        this.lines.push(line);
    }

    public function getLines(): Array<String>{
        return this.lines;
    }

    private var filename: String;
    private var file: sys.io.FileOutput;
    private var lines: Array<String> = new Array<String>();

    public function copy(): ArrayLoggerWriter{
        final newCopy = new ArrayLoggerWriter();
        newCopy.setFilename(this.getFilename());
        return newCopy;
    }

}
