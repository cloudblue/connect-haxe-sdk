package connect;


/**
    Indicates the level of the log system.
**/
enum LoggerLevel {
    /** Only writes compact error messages. **/
    Error;

    /** Only writes compact error & info level messages. **/
    Info;

    /** Writes detailed messages of all levels. **/
    Debug;
}
