/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Env;
import connect.models.Account;
import connect.models.Event;
import connect.models.Events;
import connect.models.User;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import tests.mocks.Mock;


class AccountTest {
    @Before
    public function setup() {
        Env._reset(new Dictionary()
            .setString('IGeneralApi', 'tests.mocks.GeneralApiMock'));
    }


    @Test
    public function testList() {
        // Check accounts list
        final accounts = Account.list(null);
        Assert.isType(accounts, Collection);
        Assert.areEqual(1, accounts.length());

        // Check first account
        final account = accounts.get(0);
        Assert.isType(account, Account);
        Assert.areEqual('VA-044-420', account.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('listAccounts'));
        Assert.areEqual(
            [null].toString(),
            apiMock.callArgs('listAccounts', 0).toString());
    }


    @Test
    public function testCreate() {
        // Check account
        final account = Account.create();
        Assert.isNotNull(account);
        Assert.isType(account, Account);
        Assert.areEqual('VA-044-420', account.id);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('createAccount'));
        Assert.areEqual(
            [].toString(),
            apiMock.callArgs('createAccount', 0).toString());
    }


    @Test
    public function testGetOk() {
        // Check subject
        final account = Account.get('VA-044-420');
        Assert.isNotNull(account);
        Assert.isType(account, Account);
        Assert.isType(account.events, Events);
        Assert.isType(account.events.created, Event);
        Assert.areEqual('VA-044-420', account.id);
        Assert.areEqual('2018-06-04T13:19:10+00:00', account.events.created.at.toString());
        Assert.isNull(account.events.created.by);
        Assert.isNull(account.events.inquired);
        Assert.isNull(account.events.pended);
        Assert.isNull(account.events.validated);
        Assert.isNull(account.events.updated);
        Assert.isNull(account.events.approved);
        Assert.isNull(account.events.uploaded);
        Assert.isNull(account.events.submitted);
        Assert.isNull(account.events.accepted);
        Assert.isNull(account.events.rejected);
        Assert.isNull(account.events.closed);
        Assert.areEqual('BR-704', account.brand);
        Assert.areEqual('5b3e4e1d-f9f6-e811-a95a-000d3a1f74d1', account.externalId);
        Assert.isFalse(account.sourcing);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getAccount'));
        Assert.areEqual(
            ['VA-044-420'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    @Test
    public function testGetKo() {
        // Check subject
        final account = Account.get('VA-XXX-XXX');
        Assert.isNull(account);

        // Check mocks
        final apiMock = cast(Env.getGeneralApi(), Mock);
        Assert.areEqual(1, apiMock.callCount('getAccount'));
        Assert.areEqual(
            ['VA-XXX-XXX'].toString(),
            apiMock.callArgs('getAccount', 0).toString());
    }


    @Test
    public function testListUsers() {
        final users = Account.get('VA-044-420').listUsers();
        Assert.isNotNull(users);
        Assert.isType(users, Collection);
        Assert.areEqual(1, users.length());

        final user = users.get(0);
        Assert.isType(user, User);
        Assert.areEqual('UR-460-012-274', user.id);
    }


    @Test
    public function testGetUserOk() {
        final user = Account.get('VA-044-420').getUser('UR-460-012-274');
        Assert.isNotNull(user);
        Assert.isType(user, User);
        Assert.areEqual('UR-460-012-274', user.id);
    }


    @Test
    public function testGetUserKo() {
        final user = Account.get('VA-044-420').getUser('UR-XXX-XXX-XXX');
        Assert.isNull(user);
    }
}
