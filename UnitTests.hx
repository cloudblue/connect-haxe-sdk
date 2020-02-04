/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import massive.munit.client.RichPrintClient;
import massive.munit.TestRunner;
import massive.munit.TestSuite;

// Include all mock classes here to make sure they are accesible to reflection
import tests.mocks.ApiClientMock;
import tests.mocks.FulfillmentApiMock;
import tests.mocks.GeneralApiMock;
import tests.mocks.TierApiMock;
import tests.mocks.UsageApiMock;

import tests.unit.AccountTest;
import tests.unit.AssetRequestTest;
import tests.unit.AssetTest;
import tests.unit.ConfigTest;
import tests.unit.CategoryTest;
import tests.unit.ConfigurationTest;
import tests.unit.ConversationTest;
import tests.unit.DateTimeTest;
import tests.unit.DiffTest;
import tests.unit.ItemTest;
import tests.unit.MarkdownLoggerFormatterTest;
import tests.unit.ModelTest;
import tests.unit.ProductTest;
import tests.unit.QueryTest;
import tests.unit.TierAccountTest;
import tests.unit.TierConfigRequestTest;
import tests.unit.TierConfigTest;
import tests.unit.UsageFileTest;


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
