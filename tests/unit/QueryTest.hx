package tests.unit;

import connect.api.Query;
import tests.mocks.Mock;


class QueryTest extends haxe.unit.TestCase {
    public function testConstructor() {
        final rql = new Query();
        this.assertEquals('', rql.toString());
    }


    public function testArrayBackwardsCompatibilityString() {
        final rql = new Query()
            .equal('product.id', 'PRD-123123123')
            .ordering(['test1', 'test2'])
            .limit(10)
            .offset(4)
            .orderBy('property');
        this.assertEquals(
            '?eq(product.id,PRD-123123123)&ordering(test1,test2)&limit=10&order_by=property&offset=4',
            rql.toString());
    }


    public function testArrayBackwardsCompatibilityArray() {
        final rql = new Query()
            .in_('product.id', ['PRD-123123123', 'PRD-123123123']);
        this.assertEquals('?in(product.id,(PRD-123123123,PRD-123123123))', rql.toString());
    }


    public function testEqual() {
        final rql = new Query()
            .equal('key', 'value');
        this.assertEquals('?eq(key,value)', rql.toString());
    }


    public function testIn() {
        final rql = new Query()
            .in_('key', ['value1', 'value2']);
        this.assertEquals('?in(key,(value1,value2))', rql.toString());
    }


    public function testSelect() {
        final rql = new Query()
            .select(['attribute']);
        this.assertEquals('?select(attribute)', rql.toString());
    }


    public function testLike() {
        final rql = new Query()
            .like('product.id', 'PR-');
        this.assertEquals('?like(product.id,PR-)', rql.toString());
    }


    public function testIlike() {
        final rql = new Query()
            .ilike('product.id', 'PR-');
        this.assertEquals('?ilike(product.id,PR-)', rql.toString());
    }


    public function testOut() {
        final rql = new Query()
            .out('product.id', ['PR-', 'CN-']);
        this.assertEquals('?out(product.id,(PR-,CN-))', rql.toString());
    }


    public function testOrderBy() {
        final rql = new Query()
            .orderBy('date');
        this.assertEquals('?order_by=date', rql.toString());
    }


    public function testNotEqual() {
        final rql = new Query()
            .notEqual('property', 'value');
        this.assertEquals('?ne(property,value)', rql.toString());
    }


    public function testGreater() {
        final rql = new Query()
            .greater('property', 'value');
        this.assertEquals('?gt(property,value)', rql.toString());
    }


    public function testGreaterOrEqual() {
        final rql = new Query()
            .greaterOrEqual('property', 'value');
        this.assertEquals('?ge(property,value)', rql.toString());
    }


    public function testLesser() {
        final rql = new Query()
            .lesser('property', 'value');
        this.assertEquals('?lt(property,value)', rql.toString());
    }


    public function testLesserOrEqual() {
        final rql = new Query()
            .lesserOrEqual('property', 'value');
        this.assertEquals('?le(property,value)', rql.toString());
    }


    public function testLimit() {
        final rql = new Query()
            .limit(10);
        this.assertEquals('?limit=10', rql.toString());
    }


    public function testOffset() {
        final rql = new Query()
            .offset(10);
        this.assertEquals('?offset=10', rql.toString());
    }


    public function testOrdering() {
        final rql = new Query()
            .ordering(['property1', 'property2']);
        this.assertEquals('?ordering(property1,property2)', rql.toString());
    }
}
