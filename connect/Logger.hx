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
    public function new(path: String, level: Int, writer: ILoggerWriter, formatter: ILoggerFormatter) {
        if (path != null) {
            this.path = (path.charAt(path.length - 1) == '/') ? path : (path + '/');
        } else {
            this.path = null;
        }
        this.level = Std.int(Math.min(Math.max(level, LEVEL_ERROR), LEVEL_DEBUG));
        this.writer = (writer != null) ? writer : new FileLoggerWriter();
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


    /** @returns The formatter for this logger. **/
    public function getFormatter(): ILoggerFormatter {
        return this.formatter;
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
     * Writes a block to the log in the specified level.
     * It adds a new line to the log after writing the block.
     * @param level Message level. One of: `LEVEL_ERROR`, `LEVEL_INFO`, `LEVEL_DEBUG`.
     * @param block Block of text to log. Lines in the text are formatted to appear as a block.
     */
    public function writeBlock(level: Int, block: String): Void {
        this.write(level, formatter.formatBlock(block));
    }


    /**
     * Writes a code block to the log in the specified level.
     * It adds a new line to the log after writing the block.
     * @param level Message level. One of: `LEVEL_ERROR`, `LEVEL_INFO`, `LEVEL_DEBUG`.
     * @param code Code to log. Text is formatted to appear as a code block.
     * @param language Language used in the block. For example, "json". Can be an empty string.
     */
    public function writeCodeBlock(level: Int, code: String, language: String): Void {
        this.write(level, formatter.formatCodeBlock(code, language));
    }


    /**
     * Writes a list to the log in the specified level.
     * It adds a new line to the log after writing the list.
     * @param level Message level. One of: `LEVEL_ERROR`, `LEVEL_INFO`, `LEVEL_DEBUG`.
     * @param list List to log. Lines are formatted to appear as a list.
     */
    public function writeList(level: Int, list: Collection<String>): Void {
        this.write(level, formatter.formatList(list));
    }


    /**
     * Writes a table to the log in the specified level. The first row should contain the
     * table header.
     * It adds a new line to the log after writing the list.
     * @param level Message level. One of: `LEVEL_ERROR`, `LEVEL_INFO`, `LEVEL_DEBUG`.
     * @param table Table to log. Rows are formatted to appear as a table.
     */
    public function writeTable(level: Int, table: Collection<Collection<String>>): Void {
        this.write(level, formatter.formatTable(table));
    }


    /**
     * Writes a message to the log in the specified level.
     * It adds a new line to the log after writing the message.
     * @param level Message level. One of: `LEVEL_ERROR`, `LEVEL_INFO`, `LEVEL_DEBUG`.
     * @param message Message to log. The message is not formatted.
     */
    public function write(level: Int, message: String): Void {
        if (this.level >= level) {
            this.writeSections();
            this.writer.writeLine(message);
        }
    }


    @:dox(hide)
    public function log(message: String): Void {
        this.error(message);
    }


    @:dox(hide)
    public function debug(message: String): Void {
        this.write(LEVEL_DEBUG, message);
    }


    @:dox(hide)
    public function info(message: String): Void {
        this.write(LEVEL_INFO, message);
    }


    @:dox(hide)
    public function notice(message: String): Void {
        this.info(message);
    }


    @:dox(hide)
    public function warning(message: String): Void {
        this.error(message);
    }


    @:dox(hide)
    public function error(message: String): Void {
        this.write(LEVEL_ERROR, message);
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
    private final writer: ILoggerWriter;
    private final formatter: ILoggerFormatter;
    private final sections: Array<LoggerSection>;
    
    
    private function writeSections(): Void {
        for (i in 0...this.sections.length) {
            if (!this.sections[i].written) {
                final section = this.formatter.formatSection(i+1, this.sections[i].name);
                this.writer.writeLine(section);
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
