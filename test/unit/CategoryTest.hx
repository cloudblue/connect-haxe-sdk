/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package test.unit;

import connect.Env;
import connect.models.Category;
import connect.models.Family;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class CategoryTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'test.mocks.GeneralApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final categories = Category.list(null);
        Assert.isType(categories, Collection);
        Assert.areEqual(1, categories.length());
        Assert.isType(categories.get(0), Category);
        Assert.areEqual('CAT-00012', categories.get(0).id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listCategories'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listCategories', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check category
        final category = Category.get('CAT-00012');
        Assert.isType(category, Category);
        Assert.isType(category.parent, Category);
        Assert.isType(category.family, Family);
        Assert.areEqual('CAT-00012', category.id);
        Assert.areEqual('Mobile Antiviruses', category.name);
        Assert.areEqual('CAT-00011', category.parent.id);
        Assert.areEqual('Antiviruses', category.parent.name);
        Assert.areEqual('FAM-000', category.family.id);
        Assert.areEqual('Root family', category.family.name);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getCategory'));
        Assert.areEqual(
            ['CAT-00012'].toString(),
            apiMock.callArgs('getCategory', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final category = Category.get('CAT-XXXXX');
        Assert.isNull(category);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getCategory'));
        Assert.areEqual(
            ['CAT-XXXXX'].toString(),
            apiMock.callArgs('getCategory', 0).toString());
    }
}
