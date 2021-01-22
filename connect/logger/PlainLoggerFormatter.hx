/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;

import connect.util.Collection;
import connect.util.DateTime;
import connect.util.Util;


@:dox(hide)
class PlainLoggerFormatter extends Base implements ILoggerFormatter {
    private static final NO_REQUEST = 'NO_REQUEST';
    private var currentRequest = NO_REQUEST;

    public function setRequest(requestId:Null<String>):Void {
        this.currentRequest = (requestId != null) ? requestId : NO_REQUEST;
    }

    public function formatSection(level: Int, sectionLevel: Int, text: String): String {
        final hashes = StringTools.rpad('', '#', sectionLevel);
        final prefix = (hashes != '')
            ? (hashes + ' ')
            : '';
        final textStr = Std.string(text);
        return '${formatPrefix(level)}$prefix$textStr';
    }

    private function formatPrefix(level: Int): String {
        return '${formatDate()}  ${formatLevel(level)}   ${this.currentRequest} - ';
    }

    private static function formatDate(): String {
        final date = DateTime.now().toString();
        return StringTools.replace(date.split('+')[0], 'T', ' ');
    }

    private static function formatLevel(level: Int): String {
        final levelNames = [
            'ERROR',
            'WARNING',
            'INFO',
            'DEBUG'
        ];
        return (level >= 0 && level < levelNames.length)
            ? levelNames[level]
            : 'LEVEL:$level';
    }

    public function formatBlock(level: Int, text: String): String {
        return this.getPrefixedLines(level, text).join('\n');
    }

    private function getPrefixedLines(level: Int, text: String): Array<String> {
        final prefix = formatPrefix(level);
        return getUnprefixedLines(level, text).map(l -> '$prefix$l');
    }

    private function getUnprefixedLines(level: Int, text: String): Array<String> {
        return Util.getLines(text).map(l -> removePrefix(l));
    }

    private static function removePrefix(text: String): String {
        final lines = Util.getLines(text);
        final fixedLines = lines.map(l -> isPrefixed(l) ? l.split('- ').slice(1).join('- ') : l);
        return fixedLines.join('\n');
    }

    private static function isPrefixed(text: String): Bool {
        final datePrefix = Std.string(text).split(' ')[0];
        return DateTime.fromString(datePrefix) != null;
    }

    public function formatCodeBlock(level: Int, text: String, language: String): String {
        return this.getPrefixedLines(level, text).join('\n');
    }

    public function formatList(level: Int, list: Collection<String>): String {
        if (list.length() > 0) {
            final prefix = formatPrefix(level);
            final formatted = list.toArray().map(function(text) {
                final lines = this.getPrefixedLines(level, text);
                lines[0] = '$prefix* ' + removePrefix(lines[0]);
                return lines.join('\n');
            }).join('\n');
            return formatted;
        } else {
            return '';
        }
    }

    public function formatTable(level: Int, table: Collection<Collection<String>>): String {
        if (table.length() > 0) {
            final prefix = formatPrefix(level);
            final rows = [for (row in table) '$prefix| ${row.join(' | ')} |'];
            final header = rows[0];
            final rest = rows.slice(1);
            return '$header\n${rest.join('\n')}';
        } else {
            return '';
        }
    }

    public function formatLine(level: Int, text: String): String {
        return this.getPrefixedLines(level, text).join('\n');
    }

    public function getFileExtension(): String {
        return 'log';
    }

    public function new() {}

    public function copy(): PlainLoggerFormatter{
        return new PlainLoggerFormatter();
    }
}
