/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

package connect.logger;

import connect.util.Collection;

/**
 * Represents the configuration of the logger. An instance can be passed to `Env.initLogger`
 * to setup the logger behaviour.
 */
class LoggerConfig extends Base {
    @:dox(hide)
    public var path_(default, null):String;
    @:dox(hide)
    public var level_(default, null):Int;
    @:dox(hide)
    public var handlers_(default, null):Collection<LoggerHandler>;
    @:dox(hide)
    public var maskedFields_(default, null):Collection<String>;
    @:dox(hide)
    public var maskedParams_(default, null):Collection<String>;
    @:dox(hide)
    public var regexMaskingList_:Collection<EReg>;
    @:dox(hide)
    public var compact_(default, null):Bool;
    @:dox(hide)
    public var beautify_(default, null):Bool;

    private static final levelTranslation:Map<String, Int> = [
        'ERROR' => Logger.LEVEL_ERROR,
        'WARNING' => Logger.LEVEL_WARNING,
        'INFO' => Logger.LEVEL_INFO,
        'DEBUG' => Logger.LEVEL_DEBUG];
    private var customHandlers:Bool;

    public function new() {
        this.path_ = 'logs';
        this.level_ = Logger.LEVEL_INFO;
        this.handlers_ = new Collection<LoggerHandler>().push(new LoggerHandler(new PlainLoggerFormatter(), new FileLoggerWriter()));
        this.maskedFields_ = new Collection<String>();
        this.maskedParams_ = new Collection<String>();
        this.compact_ = false;
        this.beautify_ = false;
        this.regexMaskingList_ = new Collection<EReg>();
        this.customHandlers = false;
    }

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
     * @param level Level of log. One of: `Logger.LEVEL_ERROR`,
     * `Logger.LEVEL_WARNING`, `Logger.LEVEL_INFO`, `Logger.LEVEL_DEBUG`.
     * @return `this` instance to support a fluent interface.
     */
    public function level(level:Int):LoggerConfig {
        this.level_ = level;
        return this;
    }

    /**
     * Sets the logging level. Default is `Logger.LEVEL_INFO`.
     * @param level Level of log.
     *  One of: `"ERROR"`, `"WARNING"`, `"INFO"`, `"DEBUG"`.
     * @return `this` instance to support a fluent interface.
     */
    public function levelName(level:String):LoggerConfig {
        if (levelTranslation.exists(level)) {
            this.level_ = levelTranslation[level];
        }
        return this;
    }

    /**
     * Sets the handlers for the logger. Default is a handler with a plain of Markdown formatter
     * (depending on whether `markdown` method was called with a `true` argument) and a file
     * writer.
     * @param handlers Collection of handlers.
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function handlers(handlers:Collection<LoggerHandler>):LoggerConfig {
        this.handlers_ = handlers.copy();
        this.customHandlers = true;
        return this;
    }

    /**
     * Sets the fields which should be masked in the logs,
     * by default only Authorization field in header is masked.
     * @param maskedFields Collection of field names (string).
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function maskedFields(maskedFields:Collection<String>):LoggerConfig {
        this.maskedFields_ = maskedFields;
        return this;
    }

    /**
     * Sets the id of the params whose value should be masked in the logs.
     * @param maskedParams Collection of param ids (string).
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function maskedParams(maskedParams:Collection<String>):LoggerConfig {
        this.maskedParams_ = maskedParams;
        return this;
    }

    /**
     * Set whether the logs must be written in beautified format (this is,
     * for JSON objects use new lines and two space indentation).
     * @param enable Whether beautified logging should be enabled (defaults to `false`).
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function beautify(enable:Bool):LoggerConfig {
        this.beautify_ = enable;
        return this;
    }

    /**
     * Sets whether the logs must be written in compact format (this is,
     * for JSON objects only prints key names or, if it has an 'id' field,
     * only the id). This is ignored if the logger is created in LEVEL_DEBUG.
     * @param enable Whether compact logging should be enabled.
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function compact(enable:Bool):LoggerConfig {
        this.compact_ = enable;
        return this;
    }

    /**
     * Set list of regexs to replace in logs strings
     * @param expressions
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function regexMasks(expressions:Collection<String>):LoggerConfig {
        for (expression in expressions) {
            expression = StringTools.startsWith(expression,"(") ? expression : "(" + expression;
            expression = StringTools.endsWith(expression,")") ? expression : expression + ")";
            this.regexMaskingList_.push(new EReg(expression, "g"));
        }
        return this;
    }


    /**
     * Sets whether the logger should use the Markdown formatter. By default,
     * the plain text formatter is used. This property only has effect if no default
     * set of logger handlers has been set.
     * @param enable Whether to use the Markdown formatter.
     * @return LoggerConfig `this` instance to support a fluent interface.
     */
    public function markdown(enable:Bool):LoggerConfig {
        if (!this.customHandlers) {
            this.handlers_ = new Collection<LoggerHandler>().push(new LoggerHandler(
                enable ? new MarkdownLoggerFormatter() : new PlainLoggerFormatter(),
                new FileLoggerWriter()
            ));
        }
        return this;
    }
}
