/*
	This file is part of the Ingram Micro CloudBlue Connect SDK.
	Copyright (c) 2019 Ingram Micro. All Rights Reserved.
 */
import test.util.ArrayLoggerWriter;
import connect.logger.MarkdownLoggerFormatter;
import connect.logger.LoggerHandler;
import connect.logger.LoggerConfig;
import connect.Env;
import connect.util.Collection;
import connect.util.Util;
import massive.munit.Assert;
import haxe.Json;

class LoggerTest {

    private static final dataTestMaskDataInObj:String = '{"apiKey":"123456","non_important_data": 1,"some_list":["a","b",{"username":"1"}],"smtp": {"user":"loguser","password":"pass"},"the_obj":{"a":"test"},"id_obj":{"id":"the id"}}';
    private static final resultTestMaskDataInObj:String = '{"apiKey":"HIDDEN FIELD","non_important_data": 1,"some_list":["a","b",{"username":"HIDDEN FIELD"}],"smtp": {"user":"loguser","password":"HIDDEN FIELD"},"the_obj":"{object}","id_obj":"the id"}';

    private static final dataTestMaskDataInList:String = '[{"apiKey":"123456","non_important_data": 1,"some_list":["a","b",{"username":"1"}],"smtp": {"user":"loguser","password":"pass"},"the_obj":{"a":"test"},"id_obj":{"id":"the id"}},{"apiKey":"123456","non_important_data": 1,"some_list":["a","b",{"username":"1"}],"smtp": {"user":"loguser","password":"pass"},"the_obj":{"a":"test"},"id_obj":{"id":"the id"}}]';
    private static final resultTestMaskDataInList:String = '[{"apiKey":"HIDDEN FIELD","non_important_data": 1,"some_list":["a","b",{"username":"HIDDEN FIELD"}],"smtp": {"user":"loguser","password":"HIDDEN FIELD"},"the_obj":"{object}","id_obj":"the id"},{"apiKey":"HIDDEN FIELD","non_important_data": 1,"some_list":["a","b",{"username":"HIDDEN FIELD"}],"smtp": {"user":"loguser","password":"HIDDEN FIELD"},"the_obj":"{object}","id_obj":"the id"}]';


    @Before
    public function setup() {
        Env._reset();
        var maskedFields:Collection<String> = new Collection().push("apiKey").push("username").push("password").push("smtpUsername").push("id_obj").push("the_obj");
        Env.initLogger(new LoggerConfig().handlers(new Collection<LoggerHandler>().push(new LoggerHandler(new MarkdownLoggerFormatter(),
        new ArrayLoggerWriter())))
        .maskedFields(maskedFields));
    }

    @Test
    public function setLevel() {
        var logConfig:LoggerConfig = new LoggerConfig();
        logConfig.level(0);
        Assert.areEqual(0, logConfig.level_);
        logConfig.level(2);
        Assert.areEqual(2, logConfig.level_);
        logConfig.level(3);
        Assert.areEqual(3, logConfig.level_);
        logConfig.levelName('ERROR');
        Assert.areEqual(0, logConfig.level_);
        logConfig.levelName('WARNING');
        Assert.areEqual(0, logConfig.level_);
        logConfig.levelName('INFO');
        Assert.areEqual(2, logConfig.level_);
        logConfig.levelName('TEST');
        Assert.areEqual(2, logConfig.level_);
        logConfig.levelName('DEBUG');
        Assert.areEqual(3, logConfig.level_);
    }


    @Test
    public function testMaskDataInObj() {
        final maskedInfo = Util.beautify(dataTestMaskDataInObj, true);
        final result = Helper.sortObject(Json.parse(maskedInfo));
        final expected = Helper.sortObject(Json.parse(resultTestMaskDataInObj));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }

    @Test
    public function testMaskDataInList() {
        final maskedInfo = Util.beautify(dataTestMaskDataInList, true);
        final result = Helper.sortObject(Json.parse(maskedInfo));
        final expected = Helper.sortObject(Json.parse(resultTestMaskDataInList));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }

}
