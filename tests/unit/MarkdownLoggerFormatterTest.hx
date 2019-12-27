/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.logger.MarkdownLoggerFormatter;


class MarkdownLoggerFormatterTest extends haxe.unit.TestCase {
    public function testFormatSection() {
        this.assertEquals('\n## Hello\n', fmt.formatSection(2, 'Hello'));
        this.assertEquals('\n# Hello\n', fmt.formatSection(1, 'Hello'));
        this.assertEquals('\nHello\n', fmt.formatSection(0, 'Hello'));
        this.assertEquals('\nHello\n', fmt.formatSection(-1, 'Hello'));
        this.assertEquals('\n# \n', fmt.formatSection(1, ''));
    }


    public function testFormatBlock() {
        this.assertEquals('\n> Hello, world\n', fmt.formatBlock('Hello, world'));
        this.assertEquals('\n> Hello\n> World\n', fmt.formatBlock('Hello\nWorld'));
        this.assertEquals('\n> Hello\n> World\n', fmt.formatBlock('Hello\r\nWorld'));
        this.assertEquals('\n> Hello\n> World\n', fmt.formatBlock('Hello\rWorld'));
        this.assertEquals('\n> \n', fmt.formatBlock(''));
    }


    public function testFormatCodeBlock() {
        final expected = '\n```json\n{"key": "value"}\n```\n';
        this.assertEquals(expected, fmt.formatCodeBlock('{"key": "value"}', 'json'));
        this.assertEquals('\n```\n\n```\n', fmt.formatCodeBlock('', ''));
    }


    public function testFormatCodeBlockWithinBlock() {
        final expected = '\n> \n> ```json\n> {"key": "value"}\n> ```\n> \n';
        this.assertEquals(
            expected,
            fmt.formatBlock(fmt.formatCodeBlock('{"key": "value"}', 'json')));
    }


    public function testFormatList() {
        final expected = '\n* Hello\n* World\n';
        final list = new Collection<String>()
            .push('Hello')
            .push('World');
        this.assertEquals(expected, fmt.formatList(list));
        this.assertEquals('\n\n', fmt.formatList(new Collection<String>()));
    }


    public function testFormatTable() {
        final expected = '\n| One | Two |\n| --- | --- |\n| 1 | 2 |\n';
        final table = new Collection<Collection<String>>()
            .push(new Collection<String>().push('One').push('Two'))
            .push(new Collection<String>().push('1').push('2'));
        this.assertEquals(expected, fmt.formatTable(table));
        this.assertEquals('\n\n', fmt.formatTable(new Collection<Collection<String>>()));
    }


    private final fmt = new MarkdownLoggerFormatter();
}
