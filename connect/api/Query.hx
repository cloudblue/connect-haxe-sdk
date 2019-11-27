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


    public function in_(property: String, array: Array<String>): Query {
        this.in__.set(property, array.copy());
        return this;
    }


    public function out(property: String, array: Array<String>): Query {
        this.out_.set(property, array.copy());
        return this;
    }


    public function limit(amount: Int): Query {
        this.limit_ = amount;
        return this;
    }


    public function orderBy(property: String): Query {
        this.orderBy_ = property;
        return this;
    }


    public function offset(page: Int): Query {
        this.offset_ = page;
        return this;
    }


    public function ordering(propertyList: Array<String>): Query {
        this.ordering_ = propertyList.copy();
        return this;
    }


    public function like(property: String, pattern: String): Query {
        this.like_.set(property, pattern);
        return this;
    }


    public function ilike(property: String, pattern: String): Query {
        this.ilike_.set(property, pattern);
        return this;
    }


    public function select(attributes: Array<String>): Query {
        this.select_ = attributes.copy();
        return this;
    }


    public function equal(property: String, value: String): Query {
        return addRelOp('eq', property, value);
    }


    public function notEqual(property: String, value: String): Query {
        return addRelOp('ne', property, value);
    }


    public function greater(property: String, value: String): Query {
        return addRelOp('gt', property, value);
    }


    public function greaterOrEqual(property: String, value: String): Query {
        return addRelOp('ge', property, value);
    }


    public function lesser(property: String, value: String): Query {
        return addRelOp('lt', property, value);
    }


    public function lesserOrEqual(property: String, value: String): Query {
        return addRelOp('le', property, value);
    }


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

        if (rql.length > 0) {
            return '?' + rql.join('&');
        } else {
            return '';
        }
    }


    public function toPlain(): String {
        final rql = new Array<String>();

        if (this.relOps.exists('eq')) {
            final arguments = this.relOps.get('eq');
            for (argument in arguments) {
                rql.push('${argument.key}=${argument.value}');
            }
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
