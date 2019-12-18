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
        return null;
    }


    public function formatCodeBlock(text: String): String {
        return null;
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
