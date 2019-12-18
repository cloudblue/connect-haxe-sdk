package connect;


/**
    This class is used to log events to a file and the output console.
**/
class Logger extends Base {
    /** Only writes compact error messages. **/
    public static final LEVEL_ERROR = 0;


    /** Only writes compact error & info level messages. **/
    public static final LEVEL_INFO = 2;


    /** Writes detailed messages of all levels. **/
    public static final LEVEL_DEBUG = 3;


    /**
        Creates a new Logger object. You don't normally create objects of this class,
        since the SDK uses the default instance provided by `Env.getLogger()`.
    **/
    public function new(path: String, level: Int, writer: LoggerWriter, formatter: ILoggerFormatter) {
        if (path != null) {
            this.path = (path.charAt(path.length - 1) == '/') ? path : (path + '/');
        } else {
            this.path = null;
        }
        this.level = Std.int(Math.min(Math.max(level, LEVEL_ERROR), LEVEL_DEBUG));
        this.writer = (writer != null) ? writer : new LoggerWriter();
        this.formatter = (formatter != null) ? formatter : new MarkdownLoggerFormatter();
        this.sections = [];
        this.setFilename('log.md');
    }


    /** @returns The path where logs are stored. **/
    public function getPath(): String {
        return this.path;
    }


    /** @returns The level of the log. One of: `LEVEL_ERROR`, `LEVEL_INFO`, `LEVEL_DEBUG`. **/
    public function getLevel(): Int {
        return this.level;
    }


    /**
        Sets the filename of the log. All future log messages will get printed to this file.
        Use `null` to only write to standard output.
    **/
    public function setFilename(filename: String): Void {
        final fullname = (this.path != null && filename != null)
            ? this.path + filename
            : null;

        if (this.writer.setFilename(fullname) && fullname != null) {
            for (section in this.sections) {
                section.written = false;
            }
        }
    }


    /** @returns The last filename that was set. **/
    public function getFilename(): String {
        final filename = this.writer.getFilename();
        final fixedFilename = (filename != null && filename.indexOf(this.path) == 0)
            ? filename.substr(filename.length)
            : filename;
        return fixedFilename;
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


    @:dox(hide)
    public function log(message: String): Void {
        this.error(message);
    }


    /**
        Writes a debug message to the log.
    **/
    public function debug(message: String): Void {
        if (this.level >= LEVEL_DEBUG) {
            this.write(message);
        }
    }


    /**
        Writes an info message to the log.
    **/
    public function info(message: String): Void {
        if (this.level >= LEVEL_INFO) {
            this.write(message);
        }
    }


    @:dox(hide)
    public function notice(message: String): Void {
        this.info(message);
    }


    @:dox(hide)
    public function warning(message: String): Void {
        this.error(message);
    }


    /**
        Writes an error message to the log
    **/
    public function error(message: String): Void {
        this.write(message);
    }


    @:dox(hide)
    public function critical(message: String): Void {
        this.error(message);
    }


    @:dox(hide)
    public function alert(message: String): Void {
        this.error(message);
    }


    @:dox(hide)
    public function emergency(message: String): Void {
        this.error(message);
    }


    private final path: String;
    private final level: Int;
    private final writer: LoggerWriter;
    private final formatter: ILoggerFormatter;
    private final sections: Array<LoggerSection>;


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
                final prefix = StringTools.rpad('', '#', i+1);
                this.writer.writeLine(prefix + ' ' + this.sections[i].name);
                this.writer.writeLine('');
                this.sections[i].written = true;
            }
        }
    }
}


private class LoggerSection {
    public final name: String;
    public var written: Bool;

    public function new(name: String) {
        this.name = name;
        this.written = false;
    }
}
