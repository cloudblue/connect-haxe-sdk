/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import massive.munit.client.RichPrintClient;
import massive.munit.TestRunner;
import massive.munit.TestSuite;

// Include all mock classes here to make sure they are accesible to reflection
import test.mocks.ApiClientMock;
import test.mocks.FulfillmentApiMock;
import test.mocks.GeneralApiMock;
import test.mocks.TierApiMock;
import test.mocks.UsageApiMock;

import test.unit.AccountTest;
import test.unit.AssetRequestTest;
import test.unit.AssetTest;
import test.unit.ConfigTest;
import test.unit.CategoryTest;
import test.unit.ConfigurationTest;
import test.unit.ConversationTest;
import test.unit.DateTimeTest;
import test.unit.DiffTest;
import test.unit.ItemTest;
import test.unit.MarkdownLoggerFormatterTest;
import test.unit.ModelTest;
import test.unit.ProductTest;
import test.unit.QueryTest;
import test.unit.TierAccountTest;
import test.unit.TierConfigRequestTest;
import test.unit.TierConfigTest;
import test.unit.UsageFileTest;


class ConnectSuite extends TestSuite {
    public function new() {
        super();
        add(ConfigTest);
        add(AccountTest);
        add(AssetRequestTest);
        add(AssetTest);
        add(CategoryTest);
        add(ConfigurationTest);
        add(ConversationTest);
        add(DateTimeTest);
        add(DiffTest);
        add(ItemTest);
        add(MarkdownLoggerFormatterTest);
        add(ModelTest);
        add(ProductTest);
        add(QueryTest);
        add(TierAccountTest);
        add(TierConfigRequestTest);
        add(TierConfigTest);
        add(UsageFileTest);
    }
}


class UnitTests {
    public static function main() {
        final client = new RichPrintClient();
        final runner = new TestRunner(client);
        runner.run([ConnectSuite]);
        //Sys.exit(ok ? 0 : -1);
    }
}
