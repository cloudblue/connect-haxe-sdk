/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

package connect.logger;

import connect.util.Collection;

/**
 * Represents a log formatter.The `Logger` uses an instance of a class that implements
 * this interface (`PlainLoggerFormatter` or `MarkdownLoggerFormatter` by default,
 * depending on the value of `LoggerConfig.markdown()`) to write log messages.
 */
interface ILoggerFormatter {
    public function formatSection(level:Int, sectionLevel:Int, text:String):String;
    public function formatBlock(level:Int, text:String):String;
    public function formatCodeBlock(level:Int, text:String, language:String):String;
    public function formatList(level:Int, list:Collection<String>):String;
    public function formatTable(level:Int, table:Collection<Collection<String>>):String;
    public function formatLine(level:Int, text:String):String;
    public function getFileExtension():String;
    public function setRequest(requestId:Null<String>):Void;
    public function copy(): ILoggerFormatter;
}
