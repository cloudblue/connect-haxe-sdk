/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;


/**
    The DateTime class provides a basic structure for date and time related
    information. DateTime instances can be created with
    
    - `new DateTime()` for a specific date,
    - `DateTime.now()` to obtain information about the current time, or
    - `DateTime.fromString()` to parse from a string.

    DateTime handles date and time information in UTC.
    A timestamp is defined as the number of milliseconds elapsed since 1st
    January 1970 UTC.
**/
class DateTime {
    /**
        Creates a new date object from the given arguments.
        The behaviour of a Date instance is only consistent across platforms if
        the the arguments describe a valid date.
        - month: 0 to 11 (note that this is zero-based)
        - day: 1 to 31
        - hour: 0 to 23
        - min: 0 to 59
        - sec: 0 to 59
    **/
    public function new(year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int) {
        this.year = year;
        this.month = month;
        this.day = day;
        this.hours = hour;
        this.minutes = min;
        this.seconds = sec;
    }


    /** Creates a date representing the current UTC time. **/
    public static function now(): DateTime {
        final date = Date.now();
        return new DateTime(
            date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(),
            date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()
        );
    }


    /**
        Creates a DateTime from the formatted string `s`. The only accepted format is
        `"YYYY-mm-ddTHH:MM:SS+00:00"`.
    **/
    public static function fromString(s: String): DateTime {
        final plusIndex = s.lastIndexOf('+');
        final strippedOffset = (plusIndex != -1)
            ? s.substring(0, plusIndex)
            : s;
        final dateTimeSplit = strippedOffset.split('T');
        final dateSplit = dateTimeSplit[0].split('-');
        final timeSplit = (dateTimeSplit.length > 1)
            ? dateTimeSplit[1].split(':')
            : '00:00:00'.split(':');
        final year = Std.parseInt(dateSplit[0]);
        if (year == null) {
            return null;
        }
        final month = (dateSplit.length > 1)
            ? (Std.parseInt(dateSplit[1]) - 1)
            : 0;
        final day = (dateSplit.length > 2)
            ? Std.parseInt(dateSplit[2])
            : 1;
        final hour = Std.parseInt(timeSplit[0]);
        final minute = (timeSplit.length > 1)
            ? Std.parseInt(timeSplit[1])
            : 0;
        final second = (timeSplit.length > 2)
            ? Std.parseInt(timeSplit[2])
            : 0;
        return new DateTime(year, month, day, hour, minute, second);
    }


    /** Returns the year of `this` DateTime (4 digits) in UTC. **/
    public function getYear():Int {
        return this.year;
    }


    /**
        Returns the month of `this` DateTime (0-11 range) in UTC.
        Note that the month number is zero-based.
    **/
    public function getMonth(): Int {
        return this.month;
    }


    /** Returns the day of `this` DateTime (1-31 range) in UTC. **/
    public function getDay(): Int {
        return this.day;
    }


    /**
        Returns the hours of `this` DateTime (0-23 range) in UTC.
    **/
    public function getHours(): Int {
        return this.hours;
    }


    /**
        Returns the minutes of `this` DateTime (0-59 range) in UTC.
    **/
    public function getMinutes(): Int {
        return this.minutes;
    }


    /** Returns the seconds of `this` DateTime (0-59 range) in UTC. **/
    public function getSeconds(): Int {
        return this.seconds;
    }


    /**
        Returns a string representation of `this` DateTime in UTC
        using the standard format `YYYY-mm-ddTHH:MM:SS+00:00`.
    **/
    public function toString(): String {
        final year = StringTools.lpad(Std.string(this.year), '0', 4);
        final month = StringTools.lpad(Std.string(this.month + 1), '0', 2);
        final day = StringTools.lpad(Std.string(this.day), '0', 2);
        final hour = StringTools.lpad(Std.string(this.hours), '0', 2);
        final minute = StringTools.lpad(Std.string(this.minutes), '0', 2);
        final second = StringTools.lpad(Std.string(this.seconds), '0', 2);
        return '$year-$month-${day}T$hour:$minute:$second+00:00';
    }


    private final year: Int;
    private final month: Int;
    private final day: Int;
    private final hours: Int;
    private final minutes: Int;
    private final seconds: Int;
}
