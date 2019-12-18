package tests.unit;

import connect.MarkdownLogFormatter;


class MarkdownLogFormatterTest extends haxe.unit.TestCase {
    public function testFormatSection() {
        final fmt = new MarkdownLogFormatter();
        this.assertEquals('## Hello', fmt.formatSection(2, 'Hello'));
        this.assertEquals('# Hello', fmt.formatSection(1, 'Hello'));
        this.assertEquals('Hello', fmt.formatSection(0, 'Hello'));
        this.assertEquals('Hello', fmt.formatSection(-1, 'Hello'));
    }


    public function testFormatBlock() {
        final fmt = new MarkdownLogFormatter();
        this.assertEquals('\n> Hello, world\n', fmt.formatBlock('Hello, world'));
        this.assertEquals('\n> Hello\n> World\n', fmt.formatBlock('Hello\nWorld'));
        this.assertEquals('\n> Hello\n> World\n', fmt.formatBlock('Hello\r\nWorld'));
        this.assertEquals('\n> Hello\n> World\n', fmt.formatBlock('Hello\rWorld'));
    }


    public function testFormatCodeBlock() {
        final expected = '\n```json\n{"key": "value"}\n```\n';
        final fmt = new MarkdownLogFormatter();
        this.assertEquals(expected, fmt.formatCodeBlock('{"key": "value"}', 'json'));
    }


    public function testFormatCodeBlockWithinBlock() {
        final expected = '\n> \n> ```json\n> {"key": "value"}\n> ```\n> \n';
        final fmt = new MarkdownLogFormatter();
        this.assertEquals(expected, fmt.formatBlock(fmt.formatCodeBlock('{"key": "value"}', 'json')));
    }
}
