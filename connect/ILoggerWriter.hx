package connect;


/**
    Represents the the fucntionality of writing logs to some output. The `Logger` uses an
    instance of a class that implements this interface (`FileLoggerWriter` by default)
    to write log messages.
**/
interface ILoggerWriter {
    /**
     * Sets the filename of the log.
     * @param filename The current filename of the log.
     * @return `true` if file has been reset, `false` otherwise.
     */
    public function setFilename(filename: String): Bool;


    /** @returns The last filename that was set. **/
    public function getFilename(): String;


    /** Writes a line to the log output. The line feed character is added by the method. **/
    public function writeLine(line: String): Void;
}
