package tests.unit;

import connect.Dictionary;
import connect.Environment;
import connect.models.Model;
import connect.models.Param;
import connect.models.Request;
import tests.mocks.Mock;


class ProductTest extends haxe.unit.TestCase {
    override public function setup() {
        Environment._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }
}
