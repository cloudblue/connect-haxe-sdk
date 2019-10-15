package connect;


/**
    This class is used to log events to a file and the output console.
**/
class Logger {
    /**
        Creates a new Logger object. You don't normally create objects of this class,
        since the SDK uses the default instance provided by `Env.getLogger()`.
    **/
    public function new(filename: String, level: LoggerLevel, writer: LoggerWriter) {
        this.level = level;
        this.sections = [];
        this.writer = (writer != null) ? writer : new LoggerWriter();
        this.writer.setFilename(filename);
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
        Writes a debug message to the log.
    **/
    public function debug(message: String): Void {
        if (this.level == Debug) {
            this.write(message);
        }
    }


    /**
        Writes an info message to the log.
    **/
    public function info(message: String): Void {
        if (this.level == Debug || this.level == Info) {
            this.write(message);
        }
    }


    /**
        Writes an error message to the log
    **/
    public function error(message: String): Void {
        this.write(message);
    }


    private var level: LoggerLevel;
    private var sections: Array<LoggerSection>;
    private var writer: LoggerWriter;


    private function write(message: String): Void {
        this.writeSections();
        this.writer.writeLine(message);
        if (this.sections.length > 0
                && '>-*|{'.indexOf(StringTools.trim(message).charAt(0)) == -1
                && message.substr(0, 3) != '```') {
            this.writer.writeLine('');
        }
    }
    
    
    private function writeSections(): Void {
        for (i in 0...this.sections.length) {
            if (!this.sections[i].written) {
                var prefix = StringTools.rpad('', '#', i+1);
                this.writer.writeLine(prefix + ' ' + this.sections[i].name);
                this.writer.writeLine('');
                this.sections[i].written = true;
            }
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
