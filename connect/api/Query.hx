/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.util.Collection;
import haxe.ds.StringMap;
import haxe.Json;


class Query extends Base {
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
    private var forceRql_: Bool;

    public function new() {
        this.in__ = new StringMap<Array<String>>();
        this.out_ = new StringMap<Array<String>>();
        this.like_ = new StringMap<String>();
        this.ilike_ = new StringMap<String>();
        this.relOps = new StringMap<Array<KeyValue>>();
        this.forceRql_ = false;
    }

    public function copy() {
        final copy = new Query();
        copy.in__ = [for (k in this.in__.keys()) k => this.in__.get(k).copy()];
        copy.out_ = [for (k in this.out_.keys()) k => this.out_.get(k).copy()];
        copy.limit_  = this.limit_;
        copy.orderBy_ = this.orderBy_;
        copy.offset_ = this.offset_;
        copy.ordering_ = (this.ordering_ != null) ? this.ordering_.copy() : null;
        copy.like_ = this.like_.copy();
        copy.ilike_ = this.ilike_.copy();
        copy.select_ = (this.select_ != null) ? this.select_.copy() : null;
        copy.relOps = [for (k in this.relOps.keys())
            k => [for (kv in this.relOps.get(k)) new KeyValue(kv.key, kv.value)]];
        return copy;
    }

    /**
     * Embeds the filters in the query defined by `Env.initDefaultQuery` in this one.
     * If the query already has an specific filter set, it is not overriden by the default
     * value.
     * @return Query
     */
    public function default_(): Query {
        final def = Env._getDefaultQuery();
        Lambda.iter([for (k in def.in__.keys()) k],
            k -> if (!this.in__.exists(k)) this.in__.set(k, def.in__.get(k).copy()));
        Lambda.iter([for (k in def.out_.keys()) k],
            k -> if (!this.out_.exists(k)) this.out_.set(k, def.out_.get(k).copy()));
        if (this.limit_ == null) this.limit_ = def.limit_;
        if (this.orderBy_ == null) this.orderBy_ = def.orderBy_;
        if (this.offset_ == null) this.offset_ = def.offset_;
        if (def.ordering_ != null) {
            if (this.ordering_ == null) this.ordering_ = [];
            Lambda.iter(def.ordering_,
                e -> if (this.ordering_.indexOf(e) == -1) this.ordering_.push(e));
        }
        Lambda.iter([for (k in def.like_.keys()) k],
            k -> if (!this.like_.exists(k)) this.like_.set(k, def.like_.get(k)));
        Lambda.iter([for (k in def.ilike_.keys()) k],
            k -> if (!this.ilike_.exists(k)) this.ilike_.set(k, def.ilike_.get(k)));
        if (def.select_ != null) {
            if (this.select_ == null) this.select_ = [];
            Lambda.iter(def.select_,
                e -> if (this.select_.indexOf(e) == -1) this.select_.push(e));
        }
        Lambda.iter([for (k in def.relOps.keys()) k],
            function (k) {
                if (this.relOps.exists(k)) {
                    final thisK = this.relOps.get(k);
                    for (kv in def.relOps.get(k)) {
                        if (Lambda.find(thisK, thisKV -> thisKV.equals(kv)) == null) {
                            thisK.push(new KeyValue(kv.key, kv.value));
                        }
                    }
                } else {
                    this.relOps.set(k, [for (kv in def.relOps.get(k)) new KeyValue(kv.key, kv.value)]);
                }
            });
        return this;
    }

    /**
     * Select objects where the specified property value is in the provided array.
     * @param property
     * @param array
     * @return Query
     */
    public function in_(property: String, array: Collection<String>): Query {
        this.in__.set(property, array.toArray().copy());
        return this;
    }

    /**
     * Select objects where the specified property value is not in the provided array.
     * @param property 
     * @param array 
     * @return Query
     */
    public function out(property: String, array: Collection<String>): Query {
        this.out_.set(property, array.toArray().copy());
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
    public function ordering(propertyList: Collection<String>): Query {
        this.ordering_ = propertyList.toArray().copy();
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
    public function select(attributes: Collection<String>): Query {
        this.select_ = attributes.toArray().copy();
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

        final likeKeys = sortStringArray([for (k in this.like_.keys()) k]);
        for (key in likeKeys) {
            rql.push('like($key,${this.like_.get(key)})');
        }

        final ilikeKeys = sortStringArray([for (k in this.ilike_.keys()) k]);
        for (key in ilikeKeys) {
            rql.push('ilike($key,${this.ilike_.get(key)})');
        }

        final inKeys = sortStringArray([for (k in this.in__.keys()) k]);
        for (key in inKeys) {
            rql.push('in($key,(${this.in__.get(key).join(',')}))');
        }

        final outKeys = sortStringArray([for (k in this.out_.keys()) k]);
        for (key in outKeys) {
            rql.push('out($key,(${this.out_.get(key).join(',')}))');
        }

        final relOpsKeys = sortStringArray([for (k in this.relOps.keys()) k]);
        for (relOp in relOpsKeys) {
            final arguments = this.relOps.get(relOp);
            for (argument in arguments) {
                rql.push('$relOp(${argument.key},${argument.value})');
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
     * If `forceRql(true)` was called on `this` Query, then it returns the
     * string in RQL syntax, making this method equivalent to `toString`
     * in that case.
     * @return String
     */
    public function toPlain(): String {
        if (!forceRql_) {
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

            if (this.ordering_ != null) {
                rql.push('ordering(${this.ordering_.join(',')})');
            }

            if (rql.length > 0) {
                return '?' + rql.join('&');
            } else {
                return '';
            }
        } else {
            return this.toString();
        }
    }

    /**
     * Returns a dynamic object with the fields of the Query.
     * @return Dynamic
     */
    public function toObject(): Dynamic {
        final obj = {
            "in": stringMapToObject(this.in__),
            "out": stringMapToObject(this.out_),
            "limit": this.limit_,
            "orderBy": this.orderBy_,
            "offset": this.offset_,
            "ordering": this.ordering_,
            "like": stringMapToObject(this.like_),
            "ilike": stringMapToObject(this.ilike_),
            "select": this.select_,
            "relOps": stringMapToObject(this.relOps),
        };
        final keys = Reflect.fields(obj).filter(function(field) {
            final value = Reflect.field(obj, field);
            switch (Type.typeof(value)) {
                case TNull:
                    return false;
                case TObject:
                    return Reflect.fields(value).length > 0;
                default:
                    return true;
            }
            return true;
        });
        final out = {};
        for (i in 0...keys.length) {
            Reflect.setField(out, keys[i], Reflect.field(obj, keys[i]));
        }
        return out;
    }

    /**
     * Returns a Json representation of the Query.
     * @return String
     */
    public function toJson(): String {
        return Json.stringify(this.toObject());
    }

    public static function fromObject(obj: Dynamic): Query {
        final select = Reflect.field(obj, 'select');
        final like = Reflect.field(obj, 'like');
        final ilike = Reflect.field(obj, 'ilike');
        final in_ = Reflect.field(obj, 'in');
        final out = Reflect.field(obj, 'out');
        final relOps = Reflect.field(obj, 'relOps');
        final ordering = Reflect.field(obj, 'ordering');
        final limit = Reflect.field(obj, 'limit');
        final orderBy = Reflect.field(obj, 'orderBy');
        final offset = Reflect.field(obj, 'offset');

        final rql = new Query();

        if (select != null) {
            rql.select_ = select;
        }

        if (like != null) {
            final fields = Reflect.fields(like);
            Lambda.iter(fields, field -> rql.like_.set(field, Reflect.field(like, field)));
        }

        if (ilike != null) {
            final fields = Reflect.fields(ilike);
            Lambda.iter(fields, field -> rql.ilike_.set(field, Reflect.field(ilike, field)));
        }

        if (in_ != null) {
            final fields = Reflect.fields(in_);
            Lambda.iter(fields, field -> rql.in__.set(field, Reflect.field(in_, field)));
        }

        if (out != null) {
            final fields = Reflect.fields(out);
            Lambda.iter(fields, field -> rql.out_.set(field, Reflect.field(out, field)));
        }

        if (relOps != null) {
            final fields = Reflect.fields(relOps);
            Lambda.iter(fields, function(field) {
                final array: Array<Dynamic> = Reflect.field(relOps, field);
                rql.relOps.set(field, array.map(kv -> new KeyValue(kv.key, kv.value)));
            });
        }

        if (ordering != null) {
            rql.ordering_ = ordering;
        }

        if (limit != null) {
            rql.limit_ = limit;
        }

        if (orderBy != null) {
            rql.orderBy_ = orderBy;
        }

        if (offset != null) {
            rql.offset_ = offset;
        }

        return rql;
    }

    public static function fromJson(json: String): Query {
        return fromObject(Json.parse(json));
    }

    /**
     * Calling this method with a `true` argument makes the
     * `toPlain` method return an RQL string representation
     * instead of a plain list of query params.
     * @param force 
     * @return Query
     */
    public function forceRql(force: Bool): Query {
        this.forceRql_ = force;
        return this;
    }

    private function addRelOp(op: String, property: String, value: String): Query {
        if (!this.relOps.exists(op)) {
            this.relOps.set(op, new Array<KeyValue>());
        }
        this.relOps.get(op).push(new KeyValue(property, value));
        return this;
    }

    private static function stringMapToObject(map: StringMap<Dynamic>): Dynamic {
        final obj = {};
        final fields = [for (k in map.keys()) k];
        Lambda.iter(fields, f -> Reflect.setField(obj, f, valueToObject(map.get(f))));
        return obj;
    }

    private static function valueToObject(value: Dynamic): Dynamic {
        switch (Type.typeof(value)) {
            case TClass(Array):
                return arrayToObject(value);
            case TClass(KeyValue):
                return value.toObject();
            default:
                return value;
        }
    }

    private static function arrayToObject(arr:Array<Dynamic>): Array<Dynamic> {
        return Lambda.map(arr, elem -> valueToObject(elem));
    }

    private static function sortStringArray(arr: Array<String>): Array<String> {
        haxe.ds.ArraySort.sort(arr, (a, b) -> Reflect.compare(a, b));
        return arr;
    }
}

private class KeyValue {
    public final key: String;
    public final value: String;

    public function new(key: String, value: String) {
        this.key = key;
        this.value = value;
    }

    public function equals(other: KeyValue): Bool {
        return this.key == other.key && this.value == other.value;
    }

    public function toObject(): Dynamic {
        return {
            'key': this.key,
            'value': this.value
        };
    }
}
