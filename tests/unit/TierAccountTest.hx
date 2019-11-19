package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Contact;
import connect.models.ContactInfo;
import connect.models.PhoneNumber;
import connect.models.Request;
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
        trace('******* $account');
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
        /*
        assertEquals('', account.contactInfo.addressLine2);
        assertEquals('tr', account.contactInfo.country);
        assertEquals('string', account.contactInfo.state);
        assertEquals('10500', account.contactInfo.postalCode);
        assertEquals('Quickstart', account.contactInfo.contact.firstName);
        assertEquals('Long Running Operation', account.contactInfo.contact.lastName);
        assertEquals('qlro@softcom.com', account.contactInfo.contact.email);
        assertEquals('', account.contactInfo.contact.phoneNumber.countryCode);
        assertEquals('', account.contactInfo.contact.phoneNumber.areaCode);
        assertEquals('', account.contactInfo.contact.phoneNumber.phoneNumber);
        assertEquals('', account.contactInfo.contact.phoneNumber.extension);

        // Check mocks
        final apiMock = cast(Env.getTierApi(), Mock);
        assertEquals(1, apiMock.callCount('getTierAccount'));
        assertEquals(
            ['TA-9861-7949-8492'].toString(),
            apiMock.callArgs('getTierAccount', 0).toString());
        */
    }


    /*
    public function testGetKo() {
        // Check subject
        final request = Request.get('PR-XXXX-XXXX-XXXX');
        assertTrue(request == null);

        // Check mocks
        final apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getRequest'));
        assertEquals(
            ['PR-XXXX-XXXX-XXXX'].toString(),
            apiMock.callArgs('getRequest', 0).toString());
    }
    */
}
