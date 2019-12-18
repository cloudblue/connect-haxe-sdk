package tests.unit;

import connect.MarkdownLogFormatter;


class MarkdownLogFormatterTest extends haxe.unit.TestCase {
    public function testFormatSection() {
        final formatter = new MarkdownLogFormatter();
        this.assertEquals('## Hello', formatter.formatSection(2, 'Hello'));
        this.assertEquals('# Hello', formatter.formatSection(1, 'Hello'));
        this.assertEquals('Hello', formatter.formatSection(0, 'Hello'));
        this.assertEquals('Hello', formatter.formatSection(-1, 'Hello'));
    }


    public function testFormatBlock() {
        final formatter = new MarkdownLogFormatter();
        this.assertEquals('> Hello, world', formatter.formatBlock('Hello, world'));
        this.assertEquals('> Hello\n> World', formatter.formatBlock('Hello\nWorld'));
        this.assertEquals('> Hello\n> World', formatter.formatBlock('Hello\r\nWorld'));
        this.assertEquals('> Hello\n> World', formatter.formatBlock('Hello\rWorld'));
    }


    public function testFormatCodeBlock() {
        final expectedSimple = '```json\n{}\n```';
        final formatter = new MarkdownLogFormatter();
        this.assertEquals(expectedSimple, formatter.formatCodeBlock('{}', 'json'));
        this.assertEquals('> Hello\n> World', formatter.formatBlock('Hello\nWorld'));
        this.assertEquals('> Hello\n> World', formatter.formatBlock('Hello\r\nWorld'));
        this.assertEquals('> Hello\n> World', formatter.formatBlock('Hello\rWorld'));
    }
}
