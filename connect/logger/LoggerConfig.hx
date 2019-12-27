/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;


/**
 * Represents the configuration of the logger. An instance can be passed to `Env.initConfig`
 * to setup the logger behaviour.
 */
class LoggerConfig extends Base {
    /**
     * Sets the path where logs will be stored. Default is "logs".
     * @param path Path for logs.
     * @return `this` instance to support a fluent interface.
     */
    public function path(path: String): LoggerConfig {
        this.path_ = path;
        return this;
    }


    /**
     * Sets the logging level. Default is `Logger.LEVEL_INFO`.
     * @param level Level of log.
     *  One of: `Logger.LEVEL_ERROR`, `Logger.LEVEL_INFO`, `Logger.LEVEL_DEBUG`.
     * @return `this` instance to support a fluent interface.
     */
    public function level(level: Int): LoggerConfig {
        this.level_ = level;
        return this;
    }


    /**
     * Sets the outputs for the logger. Default is an output with a Markdown formatter
     * and a file writer.
     * @param outputs Collection of outputs.
     * @return LoggerConfig
     */
    public function outputs(outputs: Collection<LoggerOutput>): LoggerConfig {
        this.outputs_ = outputs.copy();
        return this;
    }


    public function new() {
        this.path_ = 'logs';
        this.level_ = Logger.LEVEL_INFO;
        this.outputs_ = new Collection<LoggerOutput>()
            .push(
                new LoggerOutput(new MarkdownLoggerFormatter(),
                new FileLoggerWriter()));
    }


    public var path_(default, null): String;
    public var level_(default, null): Int;
    public var outputs_(default, null): Collection<LoggerOutput>;
}
