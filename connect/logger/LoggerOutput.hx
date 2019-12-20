package connect.logger;


class LoggerOutput {
    public final formatter: ILoggerFormatter;
    public final writer: ILoggerWriter;


    public function new(formatter: ILoggerFormatter, writer: ILoggerWriter) {
        this.formatter = formatter;
        this.writer = writer;
    }
}
