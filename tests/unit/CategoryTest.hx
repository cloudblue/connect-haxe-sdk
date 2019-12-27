/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Category;
import connect.models.Family;
import tests.mocks.Mock;


class CategoryTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        final categories = Category.list(null);
        assertTrue(Std.is(categories, Collection));
        assertEquals(1, categories.length());
        assertTrue(Std.is(categories.get(0), Category));
        assertEquals('CAT-00012', categories.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listCategories'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listCategories', 0).toString());
    }


    public function testGetOk() {
        // Check category
        final category = Category.get('CAT-00012');
        assertTrue(Std.is(category, Category));
        assertTrue(Std.is(category.parent, Category));
        assertTrue(Std.is(category.family, Family));
        assertEquals('CAT-00012', category.id);
        assertEquals('Mobile Antiviruses', category.name);
        assertEquals('CAT-00011', category.parent.id);
        assertEquals('Antiviruses', category.parent.name);
        assertEquals('FAM-000', category.family.id);
        assertEquals('Root family', category.family.name);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getCategory'));
        assertEquals(
            ['CAT-00012'].toString(),
            apiMock.callArgs('getCategory', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final category = Category.get('CAT-XXXXX');
        assertTrue(category == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getCategory'));
        assertEquals(
            ['CAT-XXXXX'].toString(),
            apiMock.callArgs('getCategory', 0).toString());
    }
}
