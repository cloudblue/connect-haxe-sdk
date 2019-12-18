package connect;

import haxe.io.Path;
import sys.FileSystem;


@:dox(hide)
class FileLoggerWriter extends Base implements ILoggerWriter {
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
        if (this.getFile() != null) {
            this.getFile().writeString(line + '\n');
            this.getFile().flush();
        }
        try {
            // This can fail if stdout has been overriden
            Sys.println(line);
        } catch (ex: Dynamic) {}
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
