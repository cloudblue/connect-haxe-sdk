/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

package connect.logger;

import connect.util.Collection;
import haxe.ds.StringMap;

/**
 * Represents the configuration of the logger. An instance can be passed to `Env.initLogger`
 * to setup the logger behaviour.
 */
class LoggerConfig extends Base {
    /**
     * Sets the path where logs will be stored. Default is "logs". When using a `Processor`
     * to process requests, the `Flow`s in the processor will use `Logger.setFilename` to switch
     * to the correct filename based on the id of the element being processed. When not using
     * the `Processor` at all, remember to call `Logger.setFilename` after initializing the Log
     * or log messages will only be printed to the standard output (usually, the terminal).
     *
     * @param path Path for logs.
     * @return `this` instance to support a fluent interface.
     */
    public function path(path:String):LoggerConfig {
        this.path_ = path;
        return this;
    }

    /**
     * Sets the logging level. Default is `Logger.LEVEL_INFO`.
     * @param level Level of log.
     *  One of: `Logger.LEVEL_ERROR`, `Logger.LEVEL_INFO`, `Logger.LEVEL_DEBUG`.
     * @return `this` instance to support a fluent interface.
     */
    public function level(level:Int):LoggerConfig {
        this.level_ = level;
        return this;
    }

    /**
     * Sets the logging level. Default is `Logger.LEVEL_INFO`.
     * @param level Level of log.
     *  One of: `ERROR`, `INFO`, `DEBUG`.
     * @return `this` instance to support a fluent interface.
     */
    public function levelName(level:String):LoggerConfig {
        this.level_ = Logger.LEVEL_INFO;
        if (this.levelTranslation.exists(level)) {
            this.level_ = this.levelTranslation[level];
        }
        return this;
    }

    /**
     * Sets the handlers for the logger. Default is a handler with a Markdown formatter
     * and a file writer.
     * @param handlers Collection of handlers.
     * @return LoggerConfig
     */
    public function handlers(handlers:Collection<LoggerHandler>):LoggerConfig {
        this.handlers_ = handlers.copy();
        return this;
    }

    /**
     * Sets the fields which should be masked in the logs,
     * by default only connect api credentials are masked
     * @param maskedFields Collection of field names (string).
     * @return LoggerConfig
     */
    public function maskedFields(maskedFields:Collection<String>):LoggerConfig {
        this.maskedFields_ = maskedFields;
        return this;
    }

    /**
     * Sets whether the logs must be written in compact format (this is,
     * for JSON objects only prints key names or, if it has an 'id' field,
     * only the id). This is ignored if the logger is created in LEVEL_DEBUG.
     * @param enable Whether compact logging should be enabled.
     * @return LoggerConfig
     */
    public function compact(enable:Bool):LoggerConfig {
        this.compact_ = enable;
        return this;
    }

    /**
     * Set list of regexs to replace in logs strings
     * @param expressions
     */
    public function regexMasks(expressions:Collection<String>) {
        for (expression in expressions) {
            expression = StringTools.startsWith(expression,"(") ? expression : "(" + expression;
            expression = StringTools.endsWith(expression,")") ? expression : expression + ")";
            this.regexMaskingList_.push(new EReg(expression, "g"));
        }
    }

    public function new() {
        this.path_ = 'logs';
        this.level_ = Logger.LEVEL_INFO;
        this.handlers_ = new Collection<LoggerHandler>().push(new LoggerHandler(new MarkdownLoggerFormatter(), new FileLoggerWriter()));
        this.maskedFields_ = new Collection<String>();
        this.compact_ = false;
        this.regexMaskingList_ = new Collection<EReg>();
    }

    public var path_(default, null):String;
    public var level_(default, null):Int;
    public var handlers_(default, null):Collection<LoggerHandler>;
    public var maskedFields_(default, null):Collection<String>;
    public var compact_(default, null):Bool;
    public var regexMaskingList_:Collection<EReg>;

    private final levelTranslation:Map<String, Int> = ["ERROR" => 0, "WARNING" => 0, "INFO" => 2, "DEBUG" => 3];
}
