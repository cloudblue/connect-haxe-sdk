class UnitTests {
    public static function main() {
        var runner = new haxe.unit.TestRunner();
        
        runner.add(new tests.unit.ConfigTest());

        runner.run();
    }
}
