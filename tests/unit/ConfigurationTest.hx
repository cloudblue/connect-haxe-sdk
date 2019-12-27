/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Dictionary;
import connect.Env;
import connect.models.Asset;
import connect.models.Param;


class ConfigurationTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'tests.mocks.FulfillmentApiMock'));
    }


    public function testGetParamByIdOk() {
        final config = Asset.get('AS-392-283-000-0').configuration;
        final param = config.getParamById('configParamId');
        assertTrue(Std.is(param, Param));
        assertEquals('configParamId', param.id);
    }


    public function testGetParamByIdKo() {
        final config = Asset.get('AS-392-283-000-0').configuration;
        final param = config.getParamById('invalid-id');
        assertTrue(param == null);
    }
}
