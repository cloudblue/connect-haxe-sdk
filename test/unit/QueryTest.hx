/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.api.Query;
import test.mocks.Mock;
import massive.munit.Assert;


class QueryTest {
    @Test
    public function testConstructor() {
        final rql = new Query();
        Assert.areEqual('', rql.toString());
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
            .in_('key', ['value1', 'value2']);
        Assert.areEqual('?in(key,(value1,value2))', rql.toString());
    }


    @Test
    public function testSelect() {
        final rql = new Query()
            .select(['attribute']);
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
            .out('product.id', ['PR-', 'CN-']);
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
            .ordering(['property1', 'property2']);
        Assert.areEqual('?ordering(property1,property2)', rql.toString());
    }


    @Test
    public function testPlain() {
        final rql = new Query()
            .equal('property', 'value')
            .limit(100);
        Assert.areEqual('?property=value&limit=100', rql.toPlain());
    }


    @Test
    public function testPlainWithOtherProperties() {
        final rql = new Query()
            .equal('property1', 'value1')
            .notEqual('property2', 'value2')
            .limit(100);
        Assert.areEqual('?property1=value1&limit=100', rql.toPlain());
    }
}
