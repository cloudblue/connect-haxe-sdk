// Include all mock classes here to make sure they are accesible to reflection
import tests.mocks.FulfillmentApiMock;


class UnitTests {
    public static function main() {
        var runner = new haxe.unit.TestRunner();
        
        runner.add(new tests.unit.ConfigTest());
        runner.add(new tests.unit.FulfillmentTest());
        runner.add(new tests.unit.AssetTest());

        runner.run();
    }
}
