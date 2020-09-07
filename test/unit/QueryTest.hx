/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.Query;
import connect.Env;
import connect.util.Collection;
import haxe.Json;
import massive.munit.Assert;

class QueryTest {
    @Before
    public function setup() {
        Env._reset();
    }

    @Test
    public function testConstructor() {
        final rql = new Query();
        Assert.areEqual('', rql.toString());
    }

    @Test
    public function testCopy() {
        final rql = new Query()
            .limit(100)
            .offset(10)
            .in_('key', new Collection<String>().push('value1').push('value2'))
            .out('product.id', new Collection<String>().push('PR-').push('CN-'))
            .select(new Collection<String>().push('attribute'))
            .like('product.id', 'PR-')
            .ilike('product.id', 'PR-')
            .equal('property1', 'value1')
            .notEqual('property2', 'value2')
            .greater('property', 'value')
            .greaterOrEqual('property', 'value')
            .lesser('property', 'value')
            .lesserOrEqual('property', 'value')
            .orderBy('date')
            .ordering(new Collection<String>().push('property1').push('property2'));
        final copy = rql.copy();
        Assert.areEqual(copy.toString(), rql.toString());
    }

    @Test
    public function testDefault() {
        final def = new Query().equal('key', 'value');
        Env.initDefaultQuery(def);
        final rql = new Query().default_();
        Assert.areEqual(rql.toString(), def.toString());
    }

    @Test
    public function testEqual() {
        final rql = new Query()
            .equal('key', 'value');
        Assert.areEqual('?eq(key,value)', rql.toString());
    }

    @Test
    public function testIn() {
        final rql = new Query()
            .in_('key', new Collection<String>().push('value1').push('value2'));
        Assert.areEqual('?in(key,(value1,value2))', rql.toString());
    }

    @Test
    public function testSelect() {
        final rql = new Query()
            .select(new Collection<String>().push('attribute'));
        Assert.areEqual('?select(attribute)', rql.toString());
    }

    @Test
    public function testLike() {
        final rql = new Query()
            .like('product.id', 'PR-');
        Assert.areEqual('?like(product.id,PR-)', rql.toString());
    }

    @Test
    public function testIlike() {
        final rql = new Query()
            .ilike('product.id', 'PR-');
        Assert.areEqual('?ilike(product.id,PR-)', rql.toString());
    }

    @Test
    public function testOut() {
        final rql = new Query()
            .out('product.id', new Collection<String>().push('PR-').push('CN-'));
        Assert.areEqual('?out(product.id,(PR-,CN-))', rql.toString());
    }

    @Test
    public function testOrderBy() {
        final rql = new Query()
            .orderBy('date');
        Assert.areEqual('?order_by=date', rql.toString());
    }

    @Test
    public function testNotEqual() {
        final rql = new Query()
            .notEqual('property', 'value');
        Assert.areEqual('?ne(property,value)', rql.toString());
    }

    @Test
    public function testGreater() {
        final rql = new Query()
            .greater('property', 'value');
        Assert.areEqual('?gt(property,value)', rql.toString());
    }

    @Test
    public function testGreaterOrEqual() {
        final rql = new Query()
            .greaterOrEqual('property', 'value');
        Assert.areEqual('?ge(property,value)', rql.toString());
    }

    @Test
    public function testLesser() {
        final rql = new Query()
            .lesser('property', 'value');
        Assert.areEqual('?lt(property,value)', rql.toString());
    }

    @Test
    public function testLesserOrEqual() {
        final rql = new Query()
            .lesserOrEqual('property', 'value');
        Assert.areEqual('?le(property,value)', rql.toString());
    }

    @Test
    public function testLimit() {
        final rql = new Query()
            .limit(10);
        Assert.areEqual('?limit=10', rql.toString());
    }

    @Test
    public function testOffset() {
        final rql = new Query()
            .offset(10);
        Assert.areEqual('?offset=10', rql.toString());
    }

    @Test
    public function testOrdering() {
        final rql = new Query()
            .ordering(new Collection<String>().push('property1').push('property2'));
        Assert.areEqual('?ordering(property1,property2)', rql.toString());
    }

    @Test
    public function testPlain() {
        final rql = new Query()
            .equal('property', 'value')
            .ordering(new Collection<String>().push('created'))
            .limit(100);
        Assert.areEqual('?property=value&limit=100&ordering(created)', rql.toPlain());
    }

    @Test
    public function testPlainWithOtherProperties() {
        final rql = new Query()
            .equal('property1', 'value1')
            .notEqual('property2', 'value2')
            .limit(100);
        Assert.areEqual('?property1=value1&limit=100', rql.toPlain());
    }

    @Test
    public function testPlainForced() {
        final rql = new Query()
            .equal('property1', 'value1')
            .notEqual('property2', 'value2')
            .limit(100)
            .forceRql(true);
        Assert.areEqual('?eq(property1,value1)&ne(property2,value2)&limit=100', rql.toPlain());
    }

    @Test
    public function testToObject() {
        final rql = new Query()
            .limit(100)
            .offset(10)
            .in_('key', new Collection<String>().push('value1').push('value2'))
            .out('product.id', new Collection<String>().push('PR-').push('CN-'))
            .select(new Collection<String>().push('attribute'))
            .like('product.id', 'PR-')
            .ilike('product.id', 'PR-')
            .equal('property1', 'value1')
            .notEqual('property2', 'value2')
            .greater('property', 'value')
            .greaterOrEqual('property', 'value')
            .lesser('property', 'value')
            .lesserOrEqual('property', 'value')
            .orderBy('date')
            .ordering(new Collection<String>().push('property1').push('property2'));
        final expected = Helper.sortObject({
            'limit': 100,
            'offset': 10,
            'in': {
                'key': ['value1', 'value2']
            },
            'out': {
                'product.id': ['PR-', 'CN-']
            },
            'select': ['attribute'],
            'like': {'product.id': 'PR-'},
            'ilike': {'product.id': 'PR-'},
            'orderBy': 'date',
            'ordering': ['property1', 'property2'],
            'relOps': {
                'eq': [
                    {
                        'key': 'property1',
                        'value': 'value1'
                    }
                ],
                'ne': [
                    {
                        'key': 'property2',
                        'value': 'value2'
                    }
                ],
                'gt': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ],
                'ge': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ],
                'lt': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ],
                'le': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ]
            }
        });
        final result = Helper.sortObject(rql.toObject());
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }

    @Test
    public function testFromObject() {
        final obj = {
            'limit': 100,
            'offset': 10,
            'in': {
                'key': ['value1', 'value2']
            },
            'out': {
                'product.id': ['PR-', 'CN-']
            },
            'select': ['attribute'],
            'like': {'product.id': 'PR-'},
            'ilike': {'product.id': 'PR-'},
            'orderBy': 'date',
            'ordering': ['property1', 'property2'],
            'relOps': {
                'eq': [
                    {
                        'key': 'property1',
                        'value': 'value1'
                    }
                ],
                'ne': [
                    {
                        'key': 'property2',
                        'value': 'value2'
                    }
                ],
                'gt': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ],
                'ge': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ],
                'lt': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ],
                'le': [
                    {
                        'key': 'property',
                        'value': 'value'
                    }
                ]
            }
        };
        final expected = new Query()
            .limit(100)
            .offset(10)
            .in_('key', new Collection<String>().push('value1').push('value2'))
            .out('product.id', new Collection<String>().push('PR-').push('CN-'))
            .select(new Collection<String>().push('attribute'))
            .like('product.id', 'PR-')
            .ilike('product.id', 'PR-')
            .equal('property1', 'value1')
            .notEqual('property2', 'value2')
            .greater('property', 'value')
            .greaterOrEqual('property', 'value')
            .lesser('property', 'value')
            .lesserOrEqual('property', 'value')
            .orderBy('date')
            .ordering(new Collection<String>().push('property1').push('property2'));
        final result = Query.fromObject(obj);
        Assert.areEqual(expected.toJson(), result.toJson());
    }
}
