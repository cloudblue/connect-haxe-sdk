/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;


/**
    Represents the functionality of writing logs to some output. The `Logger` uses an
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


    /** Writes a line to the log output. The new line character is added by the method. **/
    public function writeLine(line: String): Void;

    /** Returns full copy of writter **/
    public function copy(): ILoggerWriter;
}
