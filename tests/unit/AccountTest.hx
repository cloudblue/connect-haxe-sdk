package tests.unit;

import connect.Dictionary;
import connect.Environment;
import connect.models.Account;
//import connect.models.Model;
import tests.mocks.Mock;


class AccountTest extends haxe.unit.TestCase {
    override public function setup() {
        Environment._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check subject
        var accounts = Account.list();
        assertEquals(1, accounts.length());
        assertEquals('VA-044-420', accounts.get(0).id);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listAccounts'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listAccounts', 0).toString());
    }


    public function testCreate() {
        // Check subject
        var account = Account.create();
        assertTrue(account != null);
        assertEquals('VA-044-420', account.id);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createAccount'));
        assertEquals(
            [].toString(),
            apiMock.callArgs('createAccount', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        var account = Account.get('VA-044-420');
        assertTrue(account != null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getAccount'));
        assertEquals(
            ['VA-044-420'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        var account = Account.get('VA-XXX-XXX');
        assertTrue(account == null);

        // Check mocks
        var apiMock = cast(Environment.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getAccount'));
        assertEquals(
            ['VA-XXX-XXX'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    public function testListUsers() {
        var users = Account.get('VA-044-420').listUsers();
        assertTrue(users != null);
        assertEquals(1, users.length());
        assertEquals('UR-460-012-274', users.get(0).id);
    }


    public function testGetUserOk() {
        var user = Account.get('VA-044-420').getUser('UR-460-012-274');
        assertTrue(user != null);
        assertEquals('UR-460-012-274', user.id);
    }


    public function testGetUserKo() {
        var user = Account.get('VA-044-420').getUser('UR-XXX-XXX-XXX');
        assertTrue(user == null);
    }
}
