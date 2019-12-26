/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;


/**
 * Represents a log formatter.The `Logger` uses an instance of a class that implements
 * this interface (`MarkdownLoggerFormatter` by default) to write log messages.
 */
interface ILoggerFormatter {
    public function formatSection(level: Int, text: String): String;
    public function formatBlock(text: String): String;
    public function formatCodeBlock(text: String, language: String): String;
    public function formatList(list: Collection<String>): String;
    public function formatTable(table: Collection<Collection<String>>): String;
}
