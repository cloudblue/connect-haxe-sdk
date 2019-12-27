/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.Collection;
import connect.Config;


class ConfigTest extends haxe.unit.TestCase {
    private static final API_URL = 'http://localhost:8080/api/public/v1/';
    private static final API_KEY = 'ApiKey XXXX:YYYYY';
    private static final PRODUCT1 = 'XX-000-000-000';
    private static final PRODUCT2 = 'XX-111-000-000';


    public function test() {
        var config = new Config(API_URL, API_KEY,
            new Collection<String>().push(PRODUCT1).push(PRODUCT2), null);
        assertEquals(API_URL, config.getApiUrl());
        assertEquals(API_KEY, config.getApiKey());
        assertTrue(config.hasProduct(PRODUCT1));
        assertTrue(config.hasProduct(PRODUCT2));
        assertFalse(config.hasProduct(''));
        assertEquals('${PRODUCT1},${PRODUCT2}', config.getProductsString());
    }
}
