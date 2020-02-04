/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package test.unit;

import connect.Env;
import connect.models.Contact;
import connect.models.ContactInfo;
import connect.models.PhoneNumber;
import connect.models.TierAccount;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import test.mocks.Mock;


class TierAccountTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('ITierApi', 'test.mocks.TierApiMock'));
    }


    @Test
    public function testList() {
        // Check subject
        final accounts = TierAccount.list(null);
        Assert.isType(accounts, Collection);
        Assert.areEqual(1, accounts.length());
        Assert.isType(accounts.get(0), TierAccount);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listTierAccounts'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listTierAccounts', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
        final account = TierAccount.get('TA-9861-7949-8492');
        Assert.isType(account, TierAccount);
        Assert.isType(account.scopes, Collection);
        Assert.isType(account.contactInfo, ContactInfo);
        Assert.isType(account.contactInfo.contact, Contact);
        Assert.isType(account.contactInfo.contact.phoneNumber, PhoneNumber);
        Assert.areEqual('TA-9861-7949-8492', account.id);
        Assert.areEqual('12435', account.externalId);
        Assert.areEqual('string', account.name);
        Assert.areEqual('test', account.environment);
        Assert.areEqual(2, account.scopes.length());
        Assert.areEqual('tier1', account.scopes.get(0));
        Assert.areEqual('customer', account.scopes.get(1));
        Assert.areEqual('Yalı Mahallesi', account.contactInfo.addressLine1);
        Assert.areEqual('', account.contactInfo.addressLine2);
        Assert.areEqual('tr', account.contactInfo.country);
        Assert.areEqual('string', account.contactInfo.state);
        Assert.areEqual('10500', account.contactInfo.postalCode);
        Assert.areEqual('Quickstart', account.contactInfo.contact.firstName);
        Assert.areEqual('Long Running Operation', account.contactInfo.contact.lastName);
        Assert.areEqual('qlro@softcom.com', account.contactInfo.contact.email);
        Assert.areEqual('+90', account.contactInfo.contact.phoneNumber.countryCode);
        Assert.areEqual('546', account.contactInfo.contact.phoneNumber.areaCode);
        Assert.areEqual('6317546', account.contactInfo.contact.phoneNumber.phoneNumber);
        Assert.areEqual('', account.contactInfo.contact.phoneNumber.extension);
        Assert.areEqual('MP-54865', account.marketplace.id);
        Assert.areEqual('Germany', account.marketplace.name);
        Assert.areEqual('/media/PA-239-689/marketplaces/MP-54865/icon.png', account.marketplace.icon);
        Assert.areEqual('HB-12345-12345', account.hub.id);
        Assert.areEqual('Provider Production Hub', account.hub.name);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getTierAccount'));
        Assert.areEqual(
            ['TA-9861-7949-8492'].toString(),
            apiMock.callArgs('getTierAccount', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final request = TierAccount.get('TA-XXXX-XXXX-XXXX');
        Assert.isNull(request);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getTierAccount'));
        Assert.areEqual(
            ['TA-XXXX-XXXX-XXXX'].toString(),
            apiMock.callArgs('getTierAccount', 0).toString());
    }
}
