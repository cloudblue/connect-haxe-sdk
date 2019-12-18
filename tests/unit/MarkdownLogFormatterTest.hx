package tests.unit;

import connect.Collection;
import connect.MarkdownLogFormatter;


class MarkdownLogFormatterTest extends haxe.unit.TestCase {
    public function testFormatSection() {
        final fmt = new MarkdownLogFormatter();
        this.assertEquals('\n## Hello\n\n', fmt.formatSection(2, 'Hello'));
        this.assertEquals('\n# Hello\n\n', fmt.formatSection(1, 'Hello'));
        this.assertEquals('\nHello\n\n', fmt.formatSection(0, 'Hello'));
        this.assertEquals('\nHello\n\n', fmt.formatSection(-1, 'Hello'));
        this.assertEquals('\n# \n\n', fmt.formatSection(1, ''));
    }


    public function testFormatBlock() {
        final fmt = new MarkdownLogFormatter();
        this.assertEquals('\n> Hello, world\n\n', fmt.formatBlock('Hello, world'));
        this.assertEquals('\n> Hello\n> World\n\n', fmt.formatBlock('Hello\nWorld'));
        this.assertEquals('\n> Hello\n> World\n\n', fmt.formatBlock('Hello\r\nWorld'));
        this.assertEquals('\n> Hello\n> World\n\n', fmt.formatBlock('Hello\rWorld'));
        this.assertEquals('\n> \n\n', fmt.formatBlock(''));
    }


    public function testFormatCodeBlock() {
        final fmt = new MarkdownLogFormatter();
        final expected = '\n```json\n{"key": "value"}\n```\n\n';
        this.assertEquals(expected, fmt.formatCodeBlock('{"key": "value"}', 'json'));
        this.assertEquals('\n```\n\n```\n\n', fmt.formatCodeBlock('', ''));
    }


    public function testFormatCodeBlockWithinBlock() {
        final fmt = new MarkdownLogFormatter();
        final expected = '\n> \n> ```json\n> {"key": "value"}\n> ```\n> \n> \n\n';
        this.assertEquals(
            expected,
            fmt.formatBlock(fmt.formatCodeBlock('{"key": "value"}', 'json')));
    }


    public function testFormatList() {
        final fmt = new MarkdownLogFormatter();
        final expected = '\n* Hello\n* World\n\n';
        final list = new Collection<String>()
            .push('Hello')
            .push('World');
        this.assertEquals(expected, fmt.formatList(list));
        this.assertEquals('\n\n', fmt.formatList(new Collection<String>()));
    }


    public function testFormatTable() {
        final fmt = new MarkdownLogFormatter();
        final expected = '\n| One | Two |\n| --- | --- |\n| 1 | 2 |\n\n';
        final table = new Collection<Collection<String>>()
            .push(new Collection<String>().push('One').push('Two'))
            .push(new Collection<String>().push('1').push('2'));
        this.assertEquals(expected, fmt.formatTable(table));
        this.assertEquals('\n\n', fmt.formatTable(new Collection<Collection<String>>()));
    }


    public function testFormatLine() {
        final fmt = new MarkdownLogFormatter();
        final expected = 'Hello, world!\n';
        this.assertEquals(expected, fmt.formatLine('Hello, world!'));
    }
}
