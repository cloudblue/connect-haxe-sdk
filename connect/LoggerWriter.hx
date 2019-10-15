package connect;


class LoggerWriter {
    public function setFilename(filename: String): Void {
        this.filename = filename;
    }


    public function getFilename(): String {
        return this.filename;
    }


    public function writeLine(line: String): Void {
        if (this.getFile() != null) {
            this.getFile().writeString(line + '\r\n');
        }
        Sys.println(line);
    }


    public function new() {}


    private var filename: String;
    private var file: sys.io.FileOutput;


    private function getFile(): sys.io.FileOutput {
        if (this.file == null && this.filename != null) {
            this.file = sys.io.File.append(this.filename);
        }
        return this.file;
    }
}
