package connect;


interface ILoggerFormatter {
    public function formatSection(level: Int, text: String): String;
    public function formatBlock(text: String): String;
    public function formatCodeBlock(text: String, language: String): String;
    public function formatList(list: Collection<String>): String;
    public function formatTable(table: Collection<Collection<String>>): String;
}
