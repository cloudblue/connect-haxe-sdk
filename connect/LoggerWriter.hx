package connect;

import sys.io.FileSeek;
import haxe.ds.ListSort;
import haxe.io.Path;
import sys.FileSystem;


/**
    Represents the default LoggerWriter. The `Logger` uses an instance of this class
    to write log messages (by default to the standard output and the given filename).

    The filename can be null if you do not want to write messages to a persistent file.
**/
class LoggerWriter extends Base {
    public function new() {
        this.filename = null;
        this.file = null;
    }


    /**
        Sets the filename of the log file if it has not been previously set.

        @returns `true` if file has been reset, `false` otherwise.
    **/
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


    /** @returns The last filename that was set. **/
    public function getFilename(): String {
        return this.filename;
    }


    /** Writes a line to the log output. The line feed character is added by the method. **/
    public function writeLine(line: String): Void {
        if (this.getFile() != null) {
            this.getFile().writeString(line + '\r\n');
            this.getFile().flush();
        }
        Sys.println(line);
    }


    private var filename: String;
    private var file: sys.io.FileOutput;


    private function getFile(): sys.io.FileOutput {
        if (this.file == null && this.filename != null) {
            final path = Path.directory(this.filename);
            if (path != '' && !FileSystem.exists(path)) {
                FileSystem.createDirectory(path);
            }
        #if !js
            this.file = sys.io.File.append(this.filename);
        #else
            final content: String = sys.FileSystem.exists(this.filename)
                    && !sys.FileSystem.isDirectory(this.filename)
                ? sys.io.File.getContent(this.filename)
                : null;
            this.file = sys.io.File.write(this.filename);
            if (content != null) {
                this.file.writeString(content);
            }
        #end
        }
        return this.file;
    }
}
