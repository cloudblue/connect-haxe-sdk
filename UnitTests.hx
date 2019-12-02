// Include all mock classes here to make sure they are accesible to reflection
import tests.mocks.ApiClientMock;
import tests.mocks.FulfillmentApiMock;
import tests.mocks.GeneralApiMock;
import tests.mocks.TierApiMock;
import tests.mocks.UsageApiMock;


class UnitTests {
    public static function main() {
        var runner = new haxe.unit.TestRunner();
        
        runner.add(new tests.unit.ConfigTest());
        runner.add(new tests.unit.AccountTest());
        runner.add(new tests.unit.AssetTest());
        runner.add(new tests.unit.CategoryTest());
        runner.add(new tests.unit.ConfigurationTest());
        runner.add(new tests.unit.ConversationTest());
        runner.add(new tests.unit.DiffTest());
        runner.add(new tests.unit.ItemTest());
        runner.add(new tests.unit.ProductTest());
        runner.add(new tests.unit.QueryTest());
        runner.add(new tests.unit.RequestTest());
        runner.add(new tests.unit.TierAccountTest());
        runner.add(new tests.unit.TierConfigRequestTest());
        runner.add(new tests.unit.TierConfigTest());
        runner.add(new tests.unit.UsageFileTest());

        runner.run();
    }
}
