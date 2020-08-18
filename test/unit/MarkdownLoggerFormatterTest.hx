/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.logger.ILoggerFormatter;
import connect.logger.Logger;
import connect.logger.MarkdownLoggerFormatter;
import connect.util.Collection;
import massive.munit.Assert;

class MarkdownLoggerFormatterTest {
    private var fmt: ILoggerFormatter;

    @BeforeClass
    public function setup() {
        fmt = new MarkdownLoggerFormatter();
    }

    @Test
    public function testFormatSection() {
        Assert.areEqual('\n## Hello\n', fmt.formatSection(Logger.LEVEL_INFO, 2, 'Hello'));
        Assert.areEqual('\n# Hello\n', fmt.formatSection(Logger.LEVEL_INFO, 1, 'Hello'));
        Assert.areEqual('\nHello\n', fmt.formatSection(Logger.LEVEL_INFO, 0, 'Hello'));
        Assert.areEqual('\nHello\n', fmt.formatSection(Logger.LEVEL_INFO, -1, 'Hello'));
        Assert.areEqual('\n# \n', fmt.formatSection(Logger.LEVEL_INFO, 1, ''));
    }

    @Test
    public function testFormatBlock() {
        Assert.areEqual('\n> Hello, world\n', fmt.formatBlock(0,'Hello, world'));
        Assert.areEqual('\n> Hello\n> World\n', fmt.formatBlock(0,'Hello\nWorld'));
        Assert.areEqual('\n> Hello\n> World\n', fmt.formatBlock(0,'Hello\r\nWorld'));
        Assert.areEqual('\n> Hello\n> World\n', fmt.formatBlock(0,'Hello\rWorld'));
        Assert.areEqual('\n> \n', fmt.formatBlock(0,''));
    }

    @Test
    public function testFormatCodeBlock() {
        final expected = '\n```json\n{"key": "value"}\n```\n';
        Assert.areEqual(expected, fmt.formatCodeBlock(0,'{"key": "value"}', 'json'));
        Assert.areEqual('\n```\n\n```\n', fmt.formatCodeBlock(0,'', ''));
    }

    @Test
    public function testFormatCodeBlockWithinBlock() {
        final expected = '\n> \n> ```json\n> {"key": "value"}\n> ```\n> \n';
        Assert.areEqual(
            expected,
            fmt.formatBlock(0,fmt.formatCodeBlock(0,'{"key": "value"}', 'json')));
    }

    @Test
    public function testFormatList() {
        final expected = '\n* Hello\n* World\n';
        final list = new Collection<String>()
            .push('Hello')
            .push('World');
        Assert.areEqual(expected, fmt.formatList(0,list));
        Assert.areEqual('\n\n', fmt.formatList(0,new Collection<String>()));
    }

    @Test
    public function testFormatTable() {
        final expected = '\n| One | Two |\n| --- | --- |\n| 1 | 2 |\n';
        final table = new Collection<Collection<String>>()
            .push(new Collection<String>().push('One').push('Two'))
            .push(new Collection<String>().push('1').push('2'));
        Assert.areEqual(expected, fmt.formatTable(0,table));
        Assert.areEqual('\n\n', fmt.formatTable(0,new Collection<Collection<String>>()));
    }
}
