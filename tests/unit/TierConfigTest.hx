/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Connection;
import connect.models.Contract;
import connect.models.Events;
import connect.models.Marketplace;
import connect.models.Param;
import connect.models.Product;
import connect.models.Template;
import connect.models.TierAccount;
import connect.models.TierConfig;
import connect.models.TierConfigRequest;
import tests.mocks.Mock;


class TierConfigTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('ITierApi', 'tests.mocks.TierApiMock'));
    }


    public function testList() {
        // Check subject
        final configs = TierConfig.list(null);
        assertTrue(Std.is(configs, Collection));
        assertEquals(1, configs.length());
        assertTrue(Std.is(configs.get(0), TierConfig));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('listTierConfigs'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listTierConfigs', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final config = TierConfig.get('TC-000-000-000');
        assertTrue(Std.is(config, TierConfig));
        assertTrue(Std.is(config.account, TierAccount));
        assertTrue(Std.is(config.product, Product));
        assertTrue(Std.is(config.params, Collection));
        assertTrue(Std.is(config.connection, Connection));
        assertTrue(Std.is(config.openRequest, TierConfigRequest));
        assertTrue(Std.is(config.template, Template));
        assertTrue(Std.is(config.contract, Contract));
        assertTrue(Std.is(config.marketplace, Marketplace));
        assertTrue(Std.is(config.events, Events));
        assertEquals('TC-000-000-000', config.id);
        assertEquals('Configuration of Reseller', config.name);
        assertEquals('TA-1-000-000-000', config.account.id);
        assertEquals('PRD-000-000-000', config.product.id);
        assertEquals('Product', config.product.name);
        assertEquals(1, config.tierLevel);
        assertEquals(1, config.params.length());
        assertEquals('param_a', config.params.get(0).id);
        assertEquals('param_a_value', config.params.get(0).value);
        assertEquals('CT-9861-7949-8492', config.connection.id);
        assertEquals('production', config.connection.type);
        assertEquals('PA-9861-7949', config.connection.provider.id);
        assertEquals('Ingram Micro Prod DA', config.connection.provider.name);
        assertEquals('VA-9861-7949', config.connection.vendor.id);
        assertEquals('Large Largo and Co', config.connection.vendor.name);
        assertEquals('HB-12345-12345', config.connection.hub.id);
        assertEquals('Provider Production Hub', config.connection.hub.name);
        assertEquals('TCR-000-000-000', config.openRequest.id);
        assertEquals('TP-000-000-000', config.template.id);
        assertEquals('CRD-00000-00000-00000', config.contract.id);
        assertEquals('ACME Distribution Contract', config.contract.name);
        assertEquals('MP-54865', config.marketplace.id);
        assertEquals('Germany', config.marketplace.name);
        assertEquals('/media/PA-239-689/marketplaces/MP-54865/icon.png', config.marketplace.icon);
        assertEquals('2018-11-21T11:10:29+00:00', config.events.created.at.toString());
        assertEquals('2018-11-21T11:10:29+00:00', config.events.updated.at.toString());
        assertEquals('PA-000-000', config.events.updated.by.id);
        assertEquals('Username', config.events.updated.by.name);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('getTierConfig'));
        assertEquals(
            ['TC-000-000-000'].toString(),
            apiMock.callArgs('getTierConfig', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final config = TierConfig.get('TC-XXX-XXX-XXX');
        assertTrue(config == null);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('getTierConfig'));
        assertEquals(
            ['TC-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getTierConfig', 0).toString());
    }


    public function testGetParamByIdOk() {
        final config = TierConfig.get('TC-000-000-000');
        final param = config.getParamById('param_a');
        assertTrue(Std.is(param, Param));
        assertEquals('param_a', param.id);
        assertEquals('param_a_value', param.value);
    }


    public function testGetParamByIdKo() {
        final config = TierConfig.get('TC-000-000-000');
        final param = config.getParamById('invalid-id');
        assertTrue(param == null);
    }
}
