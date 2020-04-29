/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */

import test.util.ArrayLoggerWriter;
import connect.logger.ILoggerFormatter;
import connect.logger.LoggerHandler;
import connect.logger.LoggerConfig;
import connect.Env;
import connect.util.Collection;
import connect.util.Util;
import massive.munit.Assert;
import connect.Base;

class CustomLoggerFormatter extends Base implements ILoggerFormatter {
    public function formatSection(level:Int, text:String):String {
        return text;
    }

    public function formatBlock(level:Int, text:String):String {
        return text;
    }

    public function formatCodeBlock(level:Int, text:String, language:String):String {
        return text;
    }

    public function formatList(level:Int, lines:Collection<String>):String {
        return "list";
    }

    public function formatTable(level:Int, table:Collection<Collection<String>>):String {
        return "table";
    }

    public function new(marketPlace:String, hub:String, customer:String) {
        this.marketPlace = marketPlace;
        this.hub = hub;
        this.customer = customer;
    }

    private final marketPlace:String;
    private final hub:String;
    private final customer:String;

    public function formatLine(level:Int, text:String):String {
        var textLevel = "INFO";
        if (level == 0) {
            textLevel = "ERROR";
        }
        return textLevel + " - " + this.marketPlace + " - " + this.hub + " - " + this.customer + " - " + text;
    }
}

class CustomLoggerFormatterTest {
    private static final firstLine:String = "ERROR - MP-000-000 - HUB-1 - 1000001 - TEST FORMATTER";
    private static final secondLine:String = "INFO - MP-000-000 - HUB-1 - 1000001 - This line is formatted";

    public function setup() {
        Env._reset();
    }

    @Test
    public function testFormatter() {
        Env.initLogger(new LoggerConfig().handlers(new Collection<LoggerHandler>().push(new LoggerHandler(new CustomLoggerFormatter("MP-000-000", "HUB-1",
            "1000001"), new ArrayLoggerWriter()))));
        Env.getLogger().error("TEST FORMATTER");
        Env.getLogger().info("This line is formatted");
        final writer = cast(Env.getLogger().getHandlers().get(0).writer, ArrayLoggerWriter);
        Assert.areEqual(firstLine, writer.getLines()[0]);
        Assert.areEqual(secondLine, writer.getLines()[1]);
    }
}
