/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.logger;


@:dox(hide)
class MarkdownLoggerFormatter extends Base implements ILoggerFormatter {
    public function formatSection(level: Int, text: String): String {
        final hashes = StringTools.rpad('', '#', level);
        final prefix = (hashes != '')
            ? (hashes + ' ')
            : '';
        return '\n$prefix$text\n';
    }


    public function formatBlock(text: String): String {
        final lines = getLines(text);
        final prefixedLines = [for (line in lines) '> $line'];
        return '\n' + prefixedLines.join('\n') + '\n';
    }


    public function formatCodeBlock(text: String, language: String): String {
        final header = '\n```$language\n';
        final footer = '\n```\n';
        return header + text + footer;
    }


    public function formatList(lines: Collection<String>): String {
        if (lines.length() > 0) {
            final lines = [for (line in lines) '* $line'];
            return '\n${lines.join('\n')}\n';
        } else {
            return '\n\n';
        }
    }


    public function formatTable(table: Collection<Collection<String>>): String {
        if (table.length() > 0) {
            final rows = [for (row in table) '| ${row.join(' | ')} |'];
            final header = rows[0];
            final rest = rows.slice(1);
            return '\n$header\n| --- | --- |\n${rest.join('\n')}\n';
        } else {
            return '\n\n';
        }
    }


    public function new() {}


    private static function getLines(text: String): Array<String> {
        final windowsReplaced = StringTools.replace(text, '\r\n', '\n');
        final macosReplaced = StringTools.replace(windowsReplaced, '\r', '\n');
        return macosReplaced.split('\n');
    }
}
