/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
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
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class TierConfigTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('ITierApi', 'test.mocks.TierApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final configs = TierConfig.list(null);
        Assert.isType(configs, Collection);
        Assert.areEqual(1, configs.length());
        Assert.isType(configs.get(0), TierConfig);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listTierConfigs'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listTierConfigs', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
        final config = TierConfig.get('TC-000-000-000');
        Assert.isType(config, TierConfig);
        Assert.isType(config.account, TierAccount);
        Assert.isType(config.product, Product);
        Assert.isType(config.params, Collection);
        Assert.isType(config.connection, Connection);
        Assert.isType(config.openRequest, TierConfigRequest);
        Assert.isType(config.template, Template);
        Assert.isType(config.contract, Contract);
        Assert.isType(config.marketplace, Marketplace);
        Assert.isType(config.events, Events);
        Assert.areEqual('TC-000-000-000', config.id);
        Assert.areEqual('Configuration of Reseller', config.name);
        Assert.areEqual('TA-1-000-000-000', config.account.id);
        Assert.areEqual('PRD-000-000-000', config.product.id);
        Assert.areEqual('Product', config.product.name);
        Assert.areEqual(1, config.tierLevel);
        Assert.areEqual(1, config.params.length());
        Assert.areEqual('param_a', config.params.get(0).id);
        Assert.areEqual('param_a_value', config.params.get(0).value);
        Assert.areEqual('CT-9861-7949-8492', config.connection.id);
        Assert.areEqual('production', config.connection.type);
        Assert.areEqual('PA-9861-7949', config.connection.provider.id);
        Assert.areEqual('Ingram Micro Prod DA', config.connection.provider.name);
        Assert.areEqual('VA-9861-7949', config.connection.vendor.id);
        Assert.areEqual('Large Largo and Co', config.connection.vendor.name);
        Assert.areEqual('HB-12345-12345', config.connection.hub.id);
        Assert.areEqual('Provider Production Hub', config.connection.hub.name);
        Assert.areEqual('TCR-000-000-000', config.openRequest.id);
        Assert.areEqual('TP-000-000-000', config.template.id);
        Assert.areEqual('CRD-00000-00000-00000', config.contract.id);
        Assert.areEqual('ACME Distribution Contract', config.contract.name);
        Assert.areEqual('MP-54865', config.marketplace.id);
        Assert.areEqual('Germany', config.marketplace.name);
        Assert.areEqual('/media/PA-239-689/marketplaces/MP-54865/icon.png', config.marketplace.icon);
        Assert.areEqual('2018-11-21T11:10:29+00:00', config.events.created.at.toString());
        Assert.areEqual('2018-11-21T11:10:29+00:00', config.events.updated.at.toString());
        Assert.areEqual('PA-000-000', config.events.updated.by.id);
        Assert.areEqual('Username', config.events.updated.by.name);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getTierConfig'));
        Assert.areEqual(
            ['TC-000-000-000'].toString(),
            apiMock.callArgs('getTierConfig', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final config = TierConfig.get('TC-XXX-XXX-XXX');
        Assert.isNull(config);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getTierConfig'));
        Assert.areEqual(
            ['TC-XXX-XXX-XXX'].toString(),
            apiMock.callArgs('getTierConfig', 0).toString());
    }


    @Test
    public function testGetParamByIdOk() {
        final config = TierConfig.get('TC-000-000-000');
        final param = config.getParamById('param_a');
        Assert.isType(param, Param);
        Assert.areEqual('param_a', param.id);
        Assert.areEqual('param_a_value', param.value);
    }


    @Test
    public function testGetParamByIdKo() {
        final config = TierConfig.get('TC-000-000-000');
        final param = config.getParamById('invalid-id');
        Assert.isNull(param);
    }
}
