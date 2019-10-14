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
        this.file = sys.io.File.append(filename);
        this.level = level;
        this.sections = [];
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
        if (this.sections.length > 0 && '>-*'.indexOf(message.charAt(0)) == -1) {
            this.writeLine('');
        }
    }


    private var file: sys.io.FileOutput;
    private var level: LoggerLevel = Release;
    private var sections: Array<LoggerSection>;


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
        this.file.writeString(line + '\r\n');
        if (line != '') {
            Sys.println(line);
        }
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
