/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Env;
import connect.models.Asset;
import connect.models.Param;
import connect.util.Dictionary;
import massive.munit.Assert;


class ItemTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'test.mocks.FulfillmentApiMock'));
    }


    @Test
    public function testGetParamByIdOk() {
        final item = Asset.get('AS-392-283-000-0').items.get(0);
        final param = item.getParamById('item_parameter');
        Assert.isType(param, Param);
        Assert.areEqual('item_parameter', param.id);
        Assert.areEqual('Value 1', param.value);
    }


    @Test
    public function testGetParamByIdKo() {
        final item = Asset.get('AS-392-283-000-0').items.get(0);
        final param = item.getParamById('invalid-id');
        Assert.isNull(param);
    }
}
