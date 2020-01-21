/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;


/**
 * This class representes a handler for the Logger. An handler is composed of a formatter
 * (capable of formatting blocks, tables and lists to a specific syntax, like Markdown)
 * and a writer (capable of writing the formatted message to an output, like a file).
 */
class LoggerHandler {
    public final formatter: ILoggerFormatter;
    public final writer: ILoggerWriter;


    public function new(formatter: ILoggerFormatter, writer: ILoggerWriter) {
        this.formatter = formatter;
        this.writer = writer;
    }
}
