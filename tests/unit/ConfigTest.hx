package tests.unit;

import connect.Collection;
import connect.Config;


class ConfigTest extends haxe.unit.TestCase {
    private static inline var API_URL = 'http://localhost:8080/api/public/v1/';
    private static inline var API_KEY = 'ApiKey XXXX:YYYYY';
    private static inline var PRODUCT1 = 'XX-000-000-000';
    private static inline var PRODUCT2 = 'XX-111-000-000';


    public function test() {
        var config = new Config(API_URL, API_KEY, new Collection<String>([PRODUCT1, PRODUCT2]));
        assertEquals(API_URL, config.getApiUrl());
        assertEquals(API_KEY, config.getApiKey());
        assertTrue(config.hasProduct(PRODUCT1));
        assertTrue(config.hasProduct(PRODUCT2));
        assertFalse(config.hasProduct(''));
        assertEquals('${PRODUCT1},${PRODUCT2}', config.getProductsString());
    }
}
