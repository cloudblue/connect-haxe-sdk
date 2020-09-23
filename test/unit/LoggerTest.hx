/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.logger.Logger;
import connect.logger.LoggerHandler;
import connect.logger.LoggerConfig;
import connect.logger.MarkdownLoggerFormatter;
import connect.models.AssetRequest;
import connect.models.Model;
import connect.Env;
import connect.util.Collection;
import connect.util.Util;
import haxe.Json;
import massive.munit.Assert;
import test.util.ArrayLoggerWriter;

class LoggerTest {
    private static final dataTestMaskDataInObj:String = '{"apiKey":"123456","non_important_data": 1,"some_list":["a","b",{"username":"1"}],"smtp": {"user":"loguser","password":"pass"},"the_obj":{"a":"test"},"id_obj":{"id":"the id"}}';
    private static final resultTestMaskDataInObj:String = '{"apiKey":"******","non_important_data": 1,"some_list":["a","b",{"username":"*"}],"smtp": {"user":"loguser","password":"****"},"the_obj":"{object}","id_obj":"the id"}';

    private static final dataTestMaskDataInList:String = '[{"apiKey":"123456","non_important_data": 1,"some_list":["a","b",{"username":"1"}],"smtp": {"user":"loguser","password":"pass"},"the_obj":{"a":"test"},"id_obj":{"id":"the id"}},{"apiKey":"123456","non_important_data": 1,"some_list":["a","b",{"username":"1"}],"smtp": {"user":"loguser","password":"pass"},"the_obj":{"a":"test"},"id_obj":{"id":"the id"}}]';
    private static final resultTestMaskDataInList:String = '[{"apiKey":"******","non_important_data": 1,"some_list":["a","b",{"username":"*"}],"smtp": {"user":"loguser","password":"****"},"the_obj":"{object}","id_obj":"the id"},{"apiKey":"******","non_important_data": 1,"some_list":["a","b",{"username":"*"}],"smtp": {"user":"loguser","password":"****"},"the_obj":"{object}","id_obj":"the id"}]';

    private static final dataTestMaskDataInText:String = 'Bearer 89abddfb-2cff-4fda-83e6-13221f0c3d4f password=Ingrammicro2020&user=CloudBlue topSecret={The anwser is 42},{Sensitive data}';
    private static final dataTestNoMaskDataInText:String = 'This is a testing string with no passwords and no users';
    private static final resultTestMaskDataInText:String = '********* *********&********* topSecret=*********,*********';

    private static final MASKED_PARAM_ID = 'my_param';
    private static final MASKED_PARAM_VALUE = 'my_value';

    @Before
    public function setup() {
        Env._reset();
        final maskedFields:Collection<String> = new Collection()
            .push("apiKey")
            .push("username")
            .push("password")
            .push("smtpUsername")
            .push("id_obj")
            .push("the_obj");
        final maskedParams:Collection<String> = new Collection()
            .push(MASKED_PARAM_ID);
        final maskingRegex:Collection<String> = new Collection()
            .push("(Bearer\\s[\\d|a-f]{8}-([\\d|a-f]{4}-){3}[\\d|a-f]{12})")
            .push("(password=[^\\&]*)")
            .push("(user=[^\\s]*)")
            .push("\\{(.*?)\\}");
        final loggerConfiguration:LoggerConfig = new LoggerConfig()
            .handlers(new Collection<LoggerHandler>()
                .push(new LoggerHandler(new MarkdownLoggerFormatter(), new ArrayLoggerWriter())));
        loggerConfiguration.maskedFields(maskedFields);
        loggerConfiguration.maskedParams(maskedParams);
        loggerConfiguration.regexMasks(maskingRegex);
        Env.initLogger(loggerConfiguration);
    }

    @Test
    public function setLevel() {
        var logConfig:LoggerConfig = new LoggerConfig();
        logConfig.level(Logger.LEVEL_ERROR);
        Assert.areEqual(Logger.LEVEL_ERROR, logConfig.level_);
        logConfig.level(Logger.LEVEL_WARNING);
        Assert.areEqual(Logger.LEVEL_WARNING, logConfig.level_);
        logConfig.level(Logger.LEVEL_INFO);
        Assert.areEqual(Logger.LEVEL_INFO, logConfig.level_);
        logConfig.level(Logger.LEVEL_DEBUG);
        Assert.areEqual(Logger.LEVEL_DEBUG, logConfig.level_);
        logConfig.levelName('ERROR');
        Assert.areEqual(Logger.LEVEL_ERROR, logConfig.level_);
        logConfig.levelName('WARNING');
        Assert.areEqual(Logger.LEVEL_WARNING, logConfig.level_);
        logConfig.levelName('INFO');
        Assert.areEqual(Logger.LEVEL_INFO, logConfig.level_);
        logConfig.levelName('DEBUG');
        Assert.areEqual(Logger.LEVEL_DEBUG, logConfig.level_);
        final previousLevel = logConfig.level_;
        logConfig.levelName('TEST');
        Assert.areEqual(previousLevel, logConfig.level_);
    }

    @Test
    public function testMaskDataInObj() {
        final maskedInfo = Util.beautify(dataTestMaskDataInObj, false, true, false);
        final result = Helper.sortObject(Json.parse(maskedInfo));
        final expected = Helper.sortObject(Json.parse(resultTestMaskDataInObj));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }

    @Test
    public function testMaskDataInList() {
        final maskedList: Array<Dynamic> = Json.parse(Util.beautify(dataTestMaskDataInList, false, true, false));
        final expectedList: Array<Dynamic> = Json.parse(resultTestMaskDataInList);
        Assert.areEqual(expectedList.length, maskedList.length);
        for (i in 0...maskedList.length) {
            final expected = Helper.sortObject(expectedList[i]);
            final result = Helper.sortObject(maskedList[i]);
            Assert.areEqual(Json.stringify(expected), Json.stringify(result));
        }
    }

    @Test
    public function testMaskDataInText() {
        final maskedInfo = Util.beautify(dataTestMaskDataInText, false, true, false);
        Assert.areEqual(resultTestMaskDataInText, maskedInfo);
    }
    
    @Test
    public function testMaskNoDataInText() {
        final unMaskedInfo = Util.beautify(dataTestNoMaskDataInText, false, true, false);
        Assert.areEqual(dataTestNoMaskDataInText,unMaskedInfo);
    }

    @Test
    public function testMaskParam() {
        final request = Model.parse(AssetRequest, Json.stringify({
            asset: {
                params: [
                    {
                        id: MASKED_PARAM_ID,
                        value: MASKED_PARAM_VALUE,
                    },
                    {
                        id: 'other_param',
                        value: 'other_value',
                    }
                ]
            }
        }));

        Assert.areEqual(
            '{"asset":{"params":[{"id":"my_param","value":"********"},{"id":"other_param","value":"other_value"}]}}',
            Util.beautify(request.toString(), false, true, false)
        );
    }

    @Test
    public function testMaskPasswordParam() {
        final request = Model.parse(AssetRequest, Json.stringify({
            asset: {
                params: [
                    {
                        id: 'one_param',
                        value: 'my_value',
                        type: 'password',
                    },
                    {
                        id: 'other_param',
                        value: 'other_value',
                        type: null,
                    }
                ]
            }
        }));

        Assert.areEqual(
            '{"asset":{"params":[{"type":"password","id":"one_param","value":"********"},{"id":"other_param","value":"other_value"}]}}',
            Util.beautify(request.toString(), false, true, false)
        );
    }
}
