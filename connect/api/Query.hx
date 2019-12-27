/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import haxe.ds.StringMap;


class Query extends Base {
    public function new() {
        this.in__ = new StringMap<Array<String>>();
        this.out_ = new StringMap<Array<String>>();
        this.like_ = new StringMap<String>();
        this.ilike_ = new StringMap<String>();
        this.relOps = new StringMap<Array<KeyValue>>();
    }


    /**
     * Select objects where the specified property value is in the provided array.
     * @param property
     * @param array
     * @return Query
     */
    public function in_(property: String, array: Array<String>): Query {
        this.in__.set(property, array.copy());
        return this;
    }


    /**
     * Select objects where the specified property value is not in the provided array.
     * @param property 
     * @param array 
     * @return Query
     */
    public function out(property: String, array: Array<String>): Query {
        this.out_.set(property, array.copy());
        return this;
    }


    /**
     * Indicates the given number of objects from the start position.
     * @param amount 
     * @return Query
     */
    public function limit(amount: Int): Query {
        this.limit_ = amount;
        return this;
    }


    /**
     * Order list by given property
     * @param property 
     * @return Query
     */
    public function orderBy(property: String): Query {
        this.orderBy_ = property;
        return this;
    }


    /**
     * Offset (page) to return on paged queries.
     * @param page 
     * @return Query
     */
    public function offset(page: Int): Query {
        this.offset_ = page;
        return this;
    }


    /**
     * Order list of objects by the given properties (unlimited number of properties).
     * The list is ordered first by the first specified property, then by the second, and
     * so on. The order is specified by the prefix: + ascending order, - descending.
     * @param propertyList 
     * @return Query
     */
    public function ordering(propertyList: Array<String>): Query {
        this.ordering_ = propertyList.copy();
        return this;
    }


    /**
     * Search for the specified pattern in the specified property. The function is similar
     * to the SQL LIKE operator, though it uses the * wildcard instead of %. To specify in
     * a pattern the * symbol itself, it must be percent-encoded, that is, you need to specify
     * %2A instead of *, see the usage examples below. In addition, it is possible to use the
     * ? wildcard in the pattern to specify that any symbol will be valid in this position.
     * @param property 
     * @param pattern 
     * @return Query
     */
    public function like(property: String, pattern: String): Query {
        this.like_.set(property, pattern);
        return this;
    }


    /**
     * Same as like but case unsensitive.
     * @param property 
     * @param pattern 
     * @return Query
     */
    public function ilike(property: String, pattern: String): Query {
        this.ilike_.set(property, pattern);
        return this;
    }


    /**
     * The function is applicable to a list of resources (hereafter base resources). It receives
     * the list of attributes (up to 100 attributes) that can be primitive properties of the base
     * resources, relation names, and relation names combined with properties of related resources.
     * The output is the list of objects presenting the selected properties and related (linked)
     * resources. Normally, when relations are selected, the base resource properties are also presented
     * in the output.
     * @param attributes 
     * @return Query
     */
    public function select(attributes: Array<String>): Query {
        this.select_ = attributes.copy();
        return this;
    }


    /**
     * Select objects with a property value equal to value.
     * @param property 
     * @param value 
     * @return Query
     */
    public function equal(property: String, value: String): Query {
        return addRelOp('eq', property, value);
    }


    /**
     * Select objects with a property value not equal to value.
     * @param property 
     * @param value 
     * @return Query
     */
    public function notEqual(property: String, value: String): Query {
        return addRelOp('ne', property, value);
    }


    /**
     * Select objects with a property value greater than the value.
     * @param property 
     * @param value 
     * @return Query
     */
    public function greater(property: String, value: String): Query {
        return addRelOp('gt', property, value);
    }


    /**
     * Select objects with a property value equal or greater than the value.
     * @param property 
     * @param value 
     * @return Query
     */
    public function greaterOrEqual(property: String, value: String): Query {
        return addRelOp('ge', property, value);
    }


    /**
     * Select objects with a property value less than the value.
     * @param property 
     * @param value 
     * @return Query
     */
    public function lesser(property: String, value: String): Query {
        return addRelOp('lt', property, value);
    }


    /**
     * Select objects with a property value equal or less than the value.
     * @param property 
     * @param value 
     * @return Query
     */
    public function lesserOrEqual(property: String, value: String): Query {
        return addRelOp('le', property, value);
    }


    /**
     * Returns a string representation of `this` query in RQL syntax that can be appended
     * to a URL.
     * @return String
     */
    public function toString(): String {
        final rql = new Array<String>();

        if (this.select_ != null) {
            rql.push('select(${this.select_.join(',')})');
        }

        final likeKeys = this.like_.keys();
        if (likeKeys.hasNext()) {
            for (key in likeKeys) {
                rql.push('like($key,${this.like_.get(key)})');
            }
        }

        final ilikeKeys = this.ilike_.keys();
        if (ilikeKeys.hasNext()) {
            for (key in ilikeKeys) {
                rql.push('ilike($key,${this.ilike_.get(key)})');
            }
        }

        final inKeys = this.in__.keys();
        if (inKeys.hasNext()) {
            for (key in inKeys) {
                rql.push('in($key,(${this.in__.get(key).join(',')}))');
            }
        }

        final outKeys = this.out_.keys();
        if (outKeys.hasNext()) {
            for (key in outKeys) {
                rql.push('out($key,(${this.out_.get(key).join(',')}))');
            }
        }

        final relOpsKeys = this.relOps.keys();
        if (relOpsKeys.hasNext()) {
            for (relOp in relOpsKeys) {
                final arguments = this.relOps.get(relOp);
                for (argument in arguments) {
                    rql.push('$relOp(${argument.key},${argument.value})');
                }
            }
        }

        if (this.ordering_ != null) {
            rql.push('ordering(${this.ordering_.join(',')})');
        }

        if (this.limit_ != null) {
            rql.push('limit=${this.limit_}');
        }

        if (this.orderBy_ != null) {
            rql.push('order_by=${this.orderBy_}');
        }

        if (this.offset_ != null) {
            rql.push('offset=${this.offset_}');
        }

        return (rql.length > 0) ? ('?' + rql.join('&')) : '';
    }


    /**
     * Returns a string representation of `this` Query with the parameters
     * compatible with query params syntax. It can be appended to a URL.
     * @return String
     */
    public function toPlain(): String {
        final rql = new Array<String>();

        if (this.relOps.exists('eq')) {
            final arguments = this.relOps.get('eq');
            for (argument in arguments) {
                rql.push('${argument.key}=${argument.value}');
            }
        }

        if (this.limit_ != null) {
            rql.push('limit=${this.limit_}');
        }

        if (this.orderBy_ != null) {
            rql.push('order_by=${this.orderBy_}');
        }

        if (this.offset_ != null) {
            rql.push('offset=${this.offset_}');
        }

        if (rql.length > 0) {
            return '?' + rql.join('&');
        } else {
            return '';
        }
    }


    private var in__: StringMap<Array<String>>;
    private var out_: StringMap<Array<String>>;
    private var limit_: Null<Int>;
    private var orderBy_: String;
    private var offset_: Null<Int>;
    private var ordering_: Array<String>;
    private var like_: StringMap<String>;
    private var ilike_: StringMap<String>;
    private var select_: Array<String>;
    private var relOps: StringMap<Array<KeyValue>>;


    private function addRelOp(op: String, property: String, value: String): Query {
        if (!this.relOps.exists(op)) {
            this.relOps.set(op, new Array<KeyValue>());
        }
        this.relOps.get(op).push(new KeyValue(property, value));
        return this;
    }
}


private class KeyValue {
    public final key: String;
    public final value: String;


    public function new(key: String, value: String) {
        this.key = key;
        this.value = value;
    }
}
