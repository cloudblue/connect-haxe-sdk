package connect;


interface ILogFormatter {
    public function formatSection(level: Int, text: String): String;
    public function formatBlock(text: String): String;
    public function formatCodeBlock(text: String, language: String): String;
    public function formatList(content: Collection<String>): String;
    public function formatTable(content: Dictionary): String;
    public function formatText(text: String): String;
}
