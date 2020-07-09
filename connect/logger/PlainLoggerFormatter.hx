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
    private static final REQUEST_PREFIX = 'Processing request "';

    private var currentRequest = NO_REQUEST;

    public function formatSection(level: Int, text: String): String {
        final hashes = StringTools.rpad('', '#', level);
        final sectionPrefix = (hashes != '')
            ? (hashes + ' ')
            : '';
        this.parseCurrentRequest(level, text);
        return '${formatPrefix(level)}$sectionPrefix$text\n';
    }

    private function parseCurrentRequest(level: Int, text: String): Void {
        if (StringTools.startsWith(text, REQUEST_PREFIX)) {
            final request = text.split('"')[1];
            this.currentRequest = (request != '') ? request : NO_REQUEST;
        }
    }

    private function formatPrefix(level: Int): String {
        return '${formatDate()}  ${formatLevel(level)} ${this.currentRequest} - ';
    }

    private static function formatDate(): String {
        final date = DateTime.now().toString();
        return StringTools.replace(date.split('+')[0], 'T', ' ');
    }

    private static function formatLevel(level: Int): String {
        final levelNames = [
            'ERROR  ',
            'WARNING',
            'INFO   ',
            'DEBUG  '
        ];
        return levelNames[level];
    }

    public function formatBlock(level: Int, text: String): String {
        final prefix = formatPrefix(level);
        final lines = Util.getLines(text);
        final prefixedLines = [for (line in lines) '$prefix$line'];
        return prefixedLines.join('\n') + '\n';
    }

    public function formatCodeBlock(level: Int, text: String, language: String): String {
        final prefix = formatPrefix(level);
        final lines = Util.getLines(text);
        final formatted = [for (line in lines) '$prefix$line'];
        return '${formatted.join('\n')}\n';
    }

    public function formatList(level: Int, list: Collection<String>): String {
        if (list.length() > 0) {
            final prefix = formatPrefix(level);
            final formatted = [for (line in list) '$prefix* $line'];
            return '${formatted.join('\n')}\n';
        } else {
            return '\n';
        }
    }

    public function formatTable(level: Int, table: Collection<Collection<String>>): String {
        if (table.length() > 0) {
            final prefix = formatPrefix(level);
            final rows = [for (row in table) '$prefix| ${row.join(' | ')} |'];
            final header = rows[0];
            final rest = rows.slice(1);
            return '$header\n${rest.join('\n')}\n';
        } else {
            return '\n';
        }
    }

    public function formatLine(level: Int, text: String): String {
        return '${formatPrefix(level)}$text\n';
    }
}
