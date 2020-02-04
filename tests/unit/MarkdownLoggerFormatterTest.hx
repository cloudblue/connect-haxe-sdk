/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.logger.MarkdownLoggerFormatter;
import connect.util.Collection;
import massive.munit.Assert;


class MarkdownLoggerFormatterTest {
    @Test
    public function testFormatSection() {
        Assert.areEqual('\n## Hello\n', fmt.formatSection(2, 'Hello'));
        Assert.areEqual('\n# Hello\n', fmt.formatSection(1, 'Hello'));
        Assert.areEqual('\nHello\n', fmt.formatSection(0, 'Hello'));
        Assert.areEqual('\nHello\n', fmt.formatSection(-1, 'Hello'));
        Assert.areEqual('\n# \n', fmt.formatSection(1, ''));
    }


    @Test
    public function testFormatBlock() {
        Assert.areEqual('\n> Hello, world\n', fmt.formatBlock('Hello, world'));
        Assert.areEqual('\n> Hello\n> World\n', fmt.formatBlock('Hello\nWorld'));
        Assert.areEqual('\n> Hello\n> World\n', fmt.formatBlock('Hello\r\nWorld'));
        Assert.areEqual('\n> Hello\n> World\n', fmt.formatBlock('Hello\rWorld'));
        Assert.areEqual('\n> \n', fmt.formatBlock(''));
    }


    @Test
    public function testFormatCodeBlock() {
        final expected = '\n```json\n{"key": "value"}\n```\n';
        Assert.areEqual(expected, fmt.formatCodeBlock('{"key": "value"}', 'json'));
        Assert.areEqual('\n```\n\n```\n', fmt.formatCodeBlock('', ''));
    }


    @Test
    public function testFormatCodeBlockWithinBlock() {
        final expected = '\n> \n> ```json\n> {"key": "value"}\n> ```\n> \n';
        Assert.areEqual(
            expected,
            fmt.formatBlock(fmt.formatCodeBlock('{"key": "value"}', 'json')));
    }


    @Test
    public function testFormatList() {
        final expected = '\n* Hello\n* World\n';
        final list = new Collection<String>()
            .push('Hello')
            .push('World');
        Assert.areEqual(expected, fmt.formatList(list));
        Assert.areEqual('\n\n', fmt.formatList(new Collection<String>()));
    }


    @Test
    public function testFormatTable() {
        final expected = '\n| One | Two |\n| --- | --- |\n| 1 | 2 |\n';
        final table = new Collection<Collection<String>>()
            .push(new Collection<String>().push('One').push('Two'))
            .push(new Collection<String>().push('1').push('2'));
        Assert.areEqual(expected, fmt.formatTable(table));
        Assert.areEqual('\n\n', fmt.formatTable(new Collection<Collection<String>>()));
    }


    private final fmt = new MarkdownLoggerFormatter();
}
