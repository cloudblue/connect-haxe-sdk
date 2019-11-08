package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Account;
import tests.mocks.Mock;


class AccountTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check accounts list
        var accounts = Account.list(null);
        assertTrue(Std.is(accounts, Collection));
        assertEquals(1, accounts.length());

        // Check first account
        var account = accounts.get(0);
        assertTrue(Std.is(account, Account));
        assertEquals('VA-044-420', account.id);

        // Check mocks
        var apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listAccounts'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listAccounts', 0).toString());
    }


    public function testCreate() {
        // Check account
        var account = Account.create();
        assertTrue(account != null);
        assertTrue(Std.is(account, Account));
        assertEquals('VA-044-420', account.id);

        // Check mocks
        var apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createAccount'));
        assertEquals(
            [].toString(),
            apiMock.callArgs('createAccount', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        var account = Account.get('VA-044-420');
        assertTrue(account != null);
        assertTrue(Std.is(account, Account));

        // Check mocks
        var apiMock = cast(Env.getGeneralApi(), Mock);
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
        var apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getAccount'));
        assertEquals(
            ['VA-XXX-XXX'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    public function testListUsers() {
        var users = Account.get('VA-044-420').listUsers();
        assertTrue(users != null);
        assertTrue(Std.is(users, Collection));
        assertEquals(1, users.length());

        var user = users.get(0);
        assertTrue(Std.is(user, User));
        assertEquals('UR-460-012-274', user.id);
    }


    public function testGetUserOk() {
        var user = Account.get('VA-044-420').getUser('UR-460-012-274');
        assertTrue(user != null);
        assertTrue(Std.is(user, User));
        assertEquals('UR-460-012-274', user.id);
    }


    public function testGetUserKo() {
        var user = Account.get('VA-044-420').getUser('UR-XXX-XXX-XXX');
        assertTrue(user == null);
    }
}
