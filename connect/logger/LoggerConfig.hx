package connect.logger;

/*
    @param level Level of log.
        One of: `Logger.LEVEL_ERROR`, `Logger.LEVEL_INFO`, `Logger.LEVEL_DEBUG`.
    @param writer The logger writer. Pass `null` to use the default file writer,
        or create your own writer class that implements the `ILoggerWriter` interface
        and pass an instance here.
    @param formatter The logger formatter. Pass `null` to use the default Markdown formatter,
        or create your own formatter class that implements the `ILoggerFormatter` interface
        and pass an instance here.
    @throws String If the logger is already initialized.
*/

class LoggerConfig extends Base {
    public function path(path: String): LoggerConfig {
        this.path_ = path;
        return this;
    }


    public function level(level: Int): LoggerConfig {
        this.level_ = level;
        return this;
    }


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
