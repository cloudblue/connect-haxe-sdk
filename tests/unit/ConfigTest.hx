package tests.unit;

import connect.Config;


class ConfigTest extends haxe.unit.TestCase {
    private static inline var API_URL = 'http://localhost:8080/api/public/v1/';
    private static inline var API_KEY = 'ApiKey XXXX:YYYYY';
    private static inline var PRODUCT1 = 'XX-000-000-000';
    private static inline var PRODUCT2 = 'XX-111-000-000';

    public function testInit() {
        Config.init(API_URL, API_KEY, [PRODUCT1, PRODUCT2]);
        assertEquals(API_URL, Config.getInstance().apiUrl);
        assertEquals(API_KEY, Config.getInstance().apiKey);
        assertTrue(Config.getInstance().hasProduct(PRODUCT1));
        assertTrue(Config.getInstance().hasProduct(PRODUCT2));
        assertFalse(Config.getInstance().hasProduct(''));
    }

    public function testGetProductsString() {
        assertEquals('${PRODUCT1},${PRODUCT2}', Config.getInstance().getProductsString());
    }
}
