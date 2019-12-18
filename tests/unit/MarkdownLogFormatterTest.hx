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


    
}
