package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Contact;
import connect.models.ContactInfo;
import connect.models.PhoneNumber;
import connect.models.TierAccount;
import tests.mocks.Mock;


class TierAccountTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('ITierApi', 'tests.mocks.TierApiMock'));
    }


    public function testList() {
        // Check subject
        final accounts = TierAccount.list(null);
        assertTrue(Std.is(accounts, Collection));
        assertEquals(1, accounts.length());
        assertTrue(Std.is(accounts.get(0), TierAccount));

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('listTierAccounts'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listTierAccounts', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final account = TierAccount.get('TA-9861-7949-8492');
        assertTrue(Std.is(account, TierAccount));
        assertTrue(Std.is(account.scope, Collection));
        assertTrue(Std.is(account.contactInfo, ContactInfo));
        assertTrue(Std.is(account.contactInfo.contact, Contact));
        assertTrue(Std.is(account.contactInfo.contact.phoneNumber, PhoneNumber));
        assertEquals('TA-9861-7949-8492', account.id);
        assertEquals('12435', account.externalId);
        assertEquals('string', account.name);
        assertEquals('test', account.environment);
        assertEquals(2, account.scope.length());
        assertEquals('tier1', account.scope.get(0));
        assertEquals('customer', account.scope.get(1));
        assertEquals('Yalı Mahallesi', account.contactInfo.addressLine1);
        assertEquals('', account.contactInfo.addressLine2);
        assertEquals('tr', account.contactInfo.country);
        assertEquals('string', account.contactInfo.state);
        assertEquals('10500', account.contactInfo.postalCode);
        assertEquals('Quickstart', account.contactInfo.contact.firstName);
        assertEquals('Long Running Operation', account.contactInfo.contact.lastName);
        assertEquals('qlro@softcom.com', account.contactInfo.contact.email);
        assertEquals('+90', account.contactInfo.contact.phoneNumber.countryCode);
        assertEquals('546', account.contactInfo.contact.phoneNumber.areaCode);
        assertEquals('6317546', account.contactInfo.contact.phoneNumber.phoneNumber);
        assertEquals('', account.contactInfo.contact.phoneNumber.extension);
        assertEquals('MP-54865', account.marketplace.id);
        assertEquals('Germany', account.marketplace.name);
        assertEquals('/media/PA-239-689/marketplaces/MP-54865/icon.png', account.marketplace.icon);
        assertEquals('HB-12345-12345', account.hub.id);
        assertEquals('Provider Production Hub', account.hub.name);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('getTierAccount'));
        assertEquals(
            ['TA-9861-7949-8492'].toString(),
            apiMock.callArgs('getTierAccount', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final request = TierAccount.get('TA-XXXX-XXXX-XXXX');
        assertTrue(request == null);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('getTierAccount'));
        assertEquals(
            ['TA-XXXX-XXXX-XXXX'].toString(),
            apiMock.callArgs('getTierAccount', 0).toString());
    }
}
