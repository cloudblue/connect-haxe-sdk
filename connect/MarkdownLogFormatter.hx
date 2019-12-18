package connect;


class MarkdownLogFormatter implements ILogFormatter {
    public function formatSection(level: Int, text: String): String {
        final hashes = StringTools.rpad('', '#', level);
        final prefix = (hashes != '')
            ? hashes + ' '
            : '';
        return prefix + text;
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


    public function formatList(content: Collection<String>): String {
        return null;
    }


    public function formatTable(content: Dictionary): String {
        return null;
    }


    public function formatText(text: String): String {
        return null;
    }


    public function new() {}


    private static function getLines(text: String): Array<String> {
        final windowsReplaced = StringTools.replace(text, '\r\n', '\n');
        final macosReplaced = StringTools.replace(windowsReplaced, '\r', '\n');
        return macosReplaced.split('\n');
    }
}
