/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.Dictionary;
import connect.Env;
import connect.models.Account;
import connect.models.Event;
import connect.models.Events;
import connect.models.User;
import tests.mocks.Mock;


class AccountTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    public function testList() {
        // Check accounts list
        final accounts = Account.list(null);
        assertTrue(Std.is(accounts, Collection));
        assertEquals(1, accounts.length());

        // Check first account
        final account = accounts.get(0);
        assertTrue(Std.is(account, Account));
        assertEquals('VA-044-420', account.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('listAccounts'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listAccounts', 0).toString());
    }


    public function testCreate() {
        // Check account
        final account = Account.create();
        assertTrue(account != null);
        assertTrue(Std.is(account, Account));
        assertEquals('VA-044-420', account.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('createAccount'));
        assertEquals(
            [].toString(),
            apiMock.callArgs('createAccount', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        final account = Account.get('VA-044-420');
        assertTrue(account != null);
        assertTrue(Std.is(account, Account));
        assertTrue(Std.is(account.events, Events));
        assertTrue(Std.is(account.events.created, Event));
        assertEquals('VA-044-420', account.id);
        assertEquals('2018-06-04T13:19:10+00:00', account.events.created.at.toString());
        assertEquals(null, account.events.created.by);
        assertEquals(null, account.events.inquired);
        assertEquals(null, account.events.pended);
        assertEquals(null, account.events.validated);
        assertEquals(null, account.events.updated);
        assertEquals(null, account.events.approved);
        assertEquals(null, account.events.uploaded);
        assertEquals(null, account.events.submitted);
        assertEquals(null, account.events.accepted);
        assertEquals(null, account.events.rejected);
        assertEquals(null, account.events.closed);
        assertEquals('BR-704', account.brand);
        assertEquals('5b3e4e1d-f9f6-e811-a95a-000d3a1f74d1', account.externalId);
        assertEquals(false, account.sourcing);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getAccount'));
        assertEquals(
            ['VA-044-420'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        final account = Account.get('VA-XXX-XXX');
        assertTrue(account == null);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        assertEquals(1, apiMock.callCount('getAccount'));
        assertEquals(
            ['VA-XXX-XXX'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    public function testListUsers() {
        final users = Account.get('VA-044-420').listUsers();
        assertTrue(users != null);
        assertTrue(Std.is(users, Collection));
        assertEquals(1, users.length());

        final user = users.get(0);
        assertTrue(Std.is(user, User));
        assertEquals('UR-460-012-274', user.id);
    }


    public function testGetUserOk() {
        final user = Account.get('VA-044-420').getUser('UR-460-012-274');
        assertTrue(user != null);
        assertTrue(Std.is(user, User));
        assertEquals('UR-460-012-274', user.id);
    }


    public function testGetUserKo() {
        final user = Account.get('VA-044-420').getUser('UR-XXX-XXX-XXX');
        assertTrue(user == null);
    }
}
