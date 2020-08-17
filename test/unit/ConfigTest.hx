/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.Config;
import connect.util.Collection;
import massive.munit.Assert;

class ConfigTest {
    private static final API_URL = 'http://localhost:8080/api/public/v1/';
    private static final API_KEY = 'ApiKey XXXX:YYYYY';
    private static final PRODUCT1 = 'XX-000-000-000';
    private static final PRODUCT2 = 'XX-111-000-000';

    @Test
    public function test() {
        var config = new Config(API_URL, API_KEY,
            new Collection<String>().push(PRODUCT1).push(PRODUCT2), null);
        Assert.areEqual(API_URL, config.getApiUrl());
        Assert.areEqual(API_KEY, config.getApiKey());
        Assert.isTrue(config.hasProduct(PRODUCT1));
        Assert.isTrue(config.hasProduct(PRODUCT2));
        Assert.isFalse(config.hasProduct(''));
        Assert.areEqual('${PRODUCT1},${PRODUCT2}', config.getProductsString());
    }
}
