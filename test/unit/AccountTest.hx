/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.logger.Logger;
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.models.Account;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import haxe.Json;
import massive.munit.Assert;
import sys.io.File;

class AccountTest {
    @Before
    public function setup() {
        Env._reset(new AccountApiClientMock());
    }

    @Test
    public function testList() {
        final accounts = Account.list(null);
        Assert.isType(accounts, Collection);
        Assert.areEqual(1, accounts.length());
        Assert.isType(accounts.get(0), Account);
        Assert.areEqual('VA-044-420', accounts.get(0).id);
    }

    @Test
    public function testCreate() {
        final account = Account.create();
        Assert.isType(account, Account);
        Assert.areEqual('VA-CREATED', account.id);
    }

    @Test
    public function testGetOk() {
        final account = Account.get('VA-044-420');
        Assert.isType(account, Account);
        Assert.areEqual('VA-044-420', account.id);
        Assert.isType(account.events, connect.models.Events);
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Account.get('VA-XXX-XXX'));
    }

    @Test
    public function testListUsers() {
        final users = Account.get('VA-044-420').listUsers();
        Assert.isType(users, Collection);
        Assert.areEqual(1, users.length());
        Assert.isType(users.get(0), connect.models.User);
        Assert.areEqual('UR-460-012-274', users.get(0).id);
    }

    @Test
    public function testGetUserOk() {
        final user = Account.get('VA-044-420').getUser('UR-460-012-274');
        Assert.isType(user, connect.models.User);
        Assert.areEqual('UR-460-012-274', user.id);
    }

    @Test
    public function testGetUserKo() {
        final user = Account.get('VA-044-420').getUser('UR-XXX-XXX-XXX');
        Assert.isNull(user);
    }
}

class AccountApiClientMock implements IApiClient {
    static final FILE = 'test/unit/data/accounts.json';
    static final USERS_FILE = 'test/unit/data/users.json';

    public function new() {
    }

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger: Logger,  ?logLevel: Null<Int> = null) : Response {
        switch (method) {
            case 'GET':
                switch (url) {
                    case 'https://api.conn.rocks/public/v1/accounts':
                        return new Response(200, File.getContent(FILE), null);
                    case 'https://api.conn.rocks/public/v1/accounts/VA-044-420':
                        final account = Json.parse(File.getContent(FILE))[0];
                        return new Response(200, Json.stringify(account), null);
                    case 'https://api.conn.rocks/public/v1/accounts/VA-044-420/users':
                        return new Response(200, File.getContent(USERS_FILE), null);
                }
            case 'POST':
                if (url == 'https://api.conn.rocks/public/v1/accounts') {
                    return new Response(200, '{"id": "VA-CREATED"}', null);
                }
        }
        return new Response(404, null, null);
    }

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String,  ?logLevel: Null<Int> = null) : Response {
        return syncRequestWithLogger(method, url, headers, body,fileArg, fileName, fileContent, certificate, new Logger(null));
    }
}
