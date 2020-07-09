/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;

import connect.util.Collection;
import connect.util.Util;


@:dox(hide)
class MarkdownLoggerFormatter extends Base implements ILoggerFormatter {
    public function formatSection(level: Int, text: String): String {
        final hashes = StringTools.rpad('', '#', level);
        final prefix = (hashes != '')
            ? (hashes + ' ')
            : '';
        return '\n$prefix$text\n';
    }

    public function formatBlock(level: Int, text: String): String {
        final lines = Util.getLines(text);
        final prefixedLines = [for (line in lines) '> $line'];
        return '\n' + prefixedLines.join('\n') + '\n';
    }

    public function formatCodeBlock(level: Int, text: String, language: String): String {
        final header = '\n```$language\n';
        final footer = '\n```\n';
        return header + text + footer;
    }

    public function formatList(level: Int, list: Collection<String>): String {
        if (list.length() > 0) {
            final formatted = [for (line in list) '* $line'];
            return '\n${formatted.join('\n')}\n';
        } else {
            return '\n\n';
        }
    }

    public function formatTable(level: Int, table: Collection<Collection<String>>): String {
        if (table.length() > 0) {
            final rows = [for (row in table) '| ${row.join(' | ')} |'];
            final header = rows[0];
            final rest = rows.slice(1);
            return '\n$header\n| --- | --- |\n${rest.join('\n')}\n';
        } else {
            return '\n\n';
        }
    }

    public function formatLine(level: Int, text: String): String {
        return text;
    }

    public function new() {}
}
