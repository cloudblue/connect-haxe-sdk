/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package test.unit;

import connect.Env;
import connect.models.Asset;
import connect.models.Param;
import connect.util.Dictionary;
import massive.munit.Assert;


class ConfigurationTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'test.mocks.FulfillmentApiMock'));
    }


    @Test
    public function testGetParamByIdOk() {
        final config = Asset.get('AS-392-283-000-0').configuration;
        final param = config.getParamById('configParamId');
        Assert.isType(param, Param);
        Assert.areEqual('configParamId', param.id);
    }


    @Test
    public function testGetParamByIdKo() {
        final config = Asset.get('AS-392-283-000-0').configuration;
        final param = config.getParamById('invalid-id');
        Assert.isNull(param);
    }
}
