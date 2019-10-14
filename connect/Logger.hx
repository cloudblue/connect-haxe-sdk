package connect;


/**
    This class is used to log events to a file and the output console.
**/
class Logger {
    /**
        Creates a new Logger object. You don't normally create objects of this class,
        since the SDK uses the default instance provided by `Env.getLogger()`.
    **/
    public function new(filename: String, level: LoggerLevel) {
        this.filename = filename;
        this.level = level;
        this.sections = [];
    }


    /** @returns The level of the log. **/
    public function getLevel(): LoggerLevel {
        return this.level;
    }


    /**
        Opens a new section in the log. This will be output as a Markdown header with the right
        level, depending on the number of opened sections. For example, at the beginning of a
        function, a section can be opened, and closed when the function finishes.
    **/
    public function openSection(name: String): Void {
        this.sections.push(new LoggerSection(name));
    }


    /**
        Closes the last opened section.
    **/
    public function closeSection(): Void {
        this.sections.pop();
    }


    /**
        Writes a debug message to the log. Release messages cannot be written by the
        developer, they are automatically written by the SDK.
    **/
    public function write(message: String): Void {
        if (this.level == Debug) {
            this._write(message);
        }
    }


    @:dox(hide)
    public function _write(message: String): Void {
        this.writeSections();
        this.writeLine(message);
        if (this.sections.length > 0
                && '>-*|{'.indexOf(StringTools.trim(message).charAt(0)) == -1
                && message.substr(0, 3) != '```') {
            this.writeLine('');
        }
    }


    private var filename: String;
    private var file: sys.io.FileOutput;
    private var level: LoggerLevel;
    private var sections: Array<LoggerSection>;


    private function getFile(): sys.io.FileOutput {
        if (this.file == null && this.filename != null) {
            this.file = sys.io.File.append(this.filename);
        }
        return this.file;
    }
    
    
    private function writeSections(): Void {
        for (i in 0...this.sections.length) {
            if (!this.sections[i].written) {
                var prefix = StringTools.rpad('', '#', i+1);
                this.writeLine(prefix + ' ' + this.sections[i].name);
                this.writeLine('');
                this.sections[i].written = true;
            }
        }
    }


    private function writeLine(line: String): Void {
        if (this.getFile() != null) {
            this.getFile().writeString(line + '\r\n');
        }
        Sys.println(line);
    }
}


private class LoggerSection {
    public var name: String;
    public var written: Bool;

    public function new(name: String) {
        this.name = name;
        this.written = false;
    }
}
