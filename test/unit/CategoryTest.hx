/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.IApiClient;
import connect.api.Response;
import connect.Env;
import connect.models.Category;
import connect.models.Family;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;
import sys.io.File;
import test.mocks.Mock;

class CategoryTest {
    @Before
    public function setup() {
        Env._reset(new CategoryApiClientMock());
    }

    @Test
    public function testList() {
        final categories = Category.list(null);
        Assert.isType(categories, Collection);
        Assert.areEqual(1, categories.length());
        Assert.isType(categories.get(0), Category);
        Assert.areEqual('CAT-00012', categories.get(0).id);
    }

    @Test
    public function testGetOk() {
        final category = Category.get('CAT-00012');
        Assert.isType(category, Category);
        Assert.isType(category.parent, Category);
        Assert.isType(category.family, Family);
        Assert.areEqual('CAT-00012', category.id);
        Assert.areEqual('Mobile Antiviruses', category.name);
        Assert.areEqual('CAT-00011', category.parent.id);
        Assert.areEqual('Antiviruses', category.parent.name);
        Assert.areEqual('FAM-000', category.family.id);
        Assert.areEqual('Root family', category.family.name);
    }

    @Test
    public function testGetKo() {
        Assert.isNull(Category.get('CAT-XXXXX'));
    }
}

class CategoryApiClientMock extends Mock implements IApiClient {
    static final FILE = 'test/unit/data/categories.json';

    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        this.calledFunction('syncRequest', [method, url, headers, body,
            fileArg, fileName, fileContent, certificate]);
        if (method == 'GET') {
            switch (url) {
                case 'https://api.conn.rocks/public/v1/categories':
                    return new Response(200, File.getContent(FILE), null);
                case 'https://api.conn.rocks/public/v1/categories/CAT-00012':
                    final category = Mock.parseJsonFile(FILE)[0];
                    return new Response(200, haxe.Json.stringify(category), null);
            }
        }
        return new Response(404, null, null);
    }
}
