import connect.util.Collection;
import connect.util.Dictionary;
import massive.munit.Assert;

class DictionaryTest {
    @Test
    public function dictToStr() {
        final itemDict = new Dictionary()
            .set('id', 'SkuB')
            .set('mpn', 'Test_mpn')
            .set('quantity', 1)
            .set('renewal', null)
            .set('params', new Collection<Dictionary>().push(
                new Dictionary()
                    .set('id', '123123123')
                    .set('name', 'Test_param')
                    .set('value', '16ec0f63')
                    .set('constraints', new Dictionary()
                        .set('required', true))
            )
        );
        final obj = {
            id: 'SkuB',
            mpn: 'Test_mpn',
            quantity: 1,
            renewal: null,
            params: [
                {
                    id: '123123123',
                    name: 'Test_param',
                    value: '16ec0f63',
                    constraints : {
                        required: true
                    }
                }
            ]
        };
        Assert.areEqual(haxe.Json.stringify(obj), itemDict.toString());
    }
}
