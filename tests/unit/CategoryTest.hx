package tests.unit;

import connect.Dictionary;
import connect.Environment;
import connect.models.Category;
import tests.mocks.Mock;


class CategoryTest extends haxe.unit.TestCase {
    override public function setup() {
        Environment._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        var categories = Category.list(null);
        assertEquals(1, categories.length());
        assertEquals('CAT-00012', categories.get(0).id);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listCategories'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listCategories', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        var category = Category.get('CAT-00012');
        assertTrue(category != null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getCategory'));
        assertEquals(
            ['CAT-00012'].toString(),
            apiMock.callArgs('getCategory', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        var category = Category.get('CAT-XXXXX');
        assertTrue(category == null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getCategory'));
        assertEquals(
            ['CAT-XXXXX'].toString(),
            apiMock.callArgs('getCategory', 0).toString());
    }
}
