// Include all mock classes here to make sure they are accesible to reflection
import tests.mocks.FulfillmentApiMock;
import tests.mocks.GeneralApiMock;


class UnitTests {
    public static function main() {
        var runner = new haxe.unit.TestRunner();
        
        runner.add(new tests.unit.ConfigTest());
        runner.add(new tests.unit.AccountTest());
        runner.add(new tests.unit.AssetTest());
        runner.add(new tests.unit.CategoryTest());
        runner.add(new tests.unit.ConversationTest());
        runner.add(new tests.unit.RequestTest());

        runner.run();
    }
}
