/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;

import haxe.ds.StringMap;

/**
    The `Diff` class stores the difference between two Haxe dynamic objects `first` and `second`.
    You can later `apply` the diff object to `first` to obtain `second`, or `swap` the diff and then
    `apply` to `second` to get `first`.
**/
class Diff {
    private final a:StringMap<Dynamic>; // Additions
    private final d:StringMap<Dynamic>; // Deletions
    private final c:StringMap<Dynamic>; // Changes

    /**
        Creates a new `Diff` storing the differences between the two objects passed. The differences basically are:

        - Additions: Fields present in `second` that are not present in `first`.
        - Deletions: Fields present in `first` that are not present in `second`.
        - Changes: Fields whose value has changed between `first` and `second`.

        The class is capable of tracking changes inside arrays.
    **/
    public function new(first:Dynamic, second:Dynamic) {
        checkStructs(first, second);
        final firstFields = Reflect.fields(first);
        final secondFields = Reflect.fields(second);
        final addedFields = [for (f in secondFields) if (!Reflect.hasField(first, f)) f];
        final deletedFields = [for (f in firstFields) if (!Reflect.hasField(second, f)) f];
        final commonFields = [for (f in firstFields) if (Reflect.hasField(second, f)) f];
        final changedFields = commonFields.filter(function(f) {
            return !areEqual(Reflect.field(first, f), Reflect.field(second, f));
        });

        // Set additions
        this.a = new StringMap<Dynamic>();
        Lambda.iter(addedFields, (f) -> this.a.set(f, Reflect.field(second, f)));

        // Set deletions
        this.d = new StringMap<Dynamic>();
        Lambda.iter(deletedFields, (f) -> this.d.set(f, Reflect.field(first, f)));

        // Set changes
        this.c = new StringMap<Dynamic>();
        Lambda.iter(changedFields, function(f) {
            final a: Dynamic = Reflect.field(first, f);
            final b: Dynamic = Reflect.field(second, f);
            if (isStruct(a) && isStruct(b)) {
                // Diff
                this.c.set(f, new Diff(a, b));
            } else if (isArray(a) && isArray(b)) {
                // [[a], [d], [c]]
                this.c.set(f, compareArrays(a, b));
            } else {
                // [old, new]
                this.c.set(f, [a, b]);
            }
        });
    }

    private static function isStruct(value:Dynamic):Bool {
        return Type.typeof(value) == TObject;
    }

    private static function isArray(value:Dynamic):Bool {
        return Std.isOfType(value, Array);
    }

    private static function checkStructs(first:Dynamic, second:Dynamic):Void {
        if (!isStruct(first) || !isStruct(second)) {
            throw 'Unsupported types in Diff. Values must be structs. '
                    + 'Got: ${Type.typeof(first)}, ${Type.typeof(second)}';
        }
    }

    private static function areEqual(first:Dynamic, second:Dynamic):Bool {
        return Std.string(Type.typeof(first)) == Std.string(Type.typeof(second))
            && Std.string(first) == Std.string(second);
    }

    private static function compareArrays(first:Array<Dynamic>, second:Array<Dynamic>):Array<Array<Dynamic>> {        
        final fixedFirst = (first.length <= second.length)
            ? first
            : first.slice(0, second.length);
        final changeList = Lambda.mapi(fixedFirst, function(i, el): Array<Dynamic> {
            final a: Dynamic = el;
            final b: Dynamic = second[i];
            if (areEqual(a, b)) {
                return null;
            } else {
                if (isStruct(a) && isStruct(b)) {
                    return [i, new Diff(a, b)];
                } else if (isArray(a) && isArray(b)) {
                    return [i, compareArrays(a, b)];
                } else {
                    return [i, a, b];
                }
            }
        });
        final changes = [for (el in changeList) el].filter(el -> el != null);
        return [
            second.slice(first.length),
            first.slice(second.length),
            changes
        ];
    }

    /**
        Applies to changes in `this` `Diff` to the dynamic object passed as argument.
        If this method is called on the `first` object passed when constructing `this`,
        then an object identical to `second` is returned.
    **/
    public function apply(obj:Dynamic):Dynamic {
        final out = Reflect.copy(obj);

        // Additions
        final addedKeys = [for (k in this.a.keys()) k];
        Lambda.iter(addedKeys, k -> Reflect.setField(out, k, this.a.get(k)));

        // Deletions
        final deletedKeys = [for (k in this.d.keys()) k];
        Lambda.iter(deletedKeys, k -> Reflect.deleteField(out, k));

        // Changes
        final changedKeys = [for (k in this.c.keys()) k];
        Lambda.iter(changedKeys, function(k) {
            final change = this.c.get(k);
            if (Std.isOfType(change, Array)) {
                if (change.length == 2) {
                    // [old, new]
                    Reflect.setField(out, k, cast(change, Array<Dynamic>)[1]);
                } else {
                    // [[a], [d], [c]]
                    final field = Reflect.field(out, k);
                    final original = (field != null) ? field : [];
                    Reflect.setField(out, k, applyArray(original, change));
                }
            } else {
                // Diff
                final field = Reflect.field(out, k);
                final original = (field != null) ? field : {};
                Reflect.setField(out, k, change.apply(original));
            }
        });

        return out;
    }

    private static function applyArray(obj:Array<Dynamic>, arr:Array<Array<Dynamic>>):Array<Dynamic> {
        // Apply deletions
        final slice = obj.slice(0, obj.length - arr[1].length);
        final deleted = (slice != null) ? slice : [];

        // Apply additions
        final added = deleted.concat(arr[0]);

        // Apply changes
        final out = added;
        Lambda.iter(arr[2], function(change: Array<Dynamic>) {
            final i = change[0];
            final originalArray: Dynamic = (out.length > i) ? out[i] : [];
            final originalObject = (out.length > i) ? out[i] : {};
            out[i] = (change.length == 3)
                ? change[2] // [i, old, new]
                : (Std.isOfType(change[1], Array))
                    ? applyArray(originalArray, change[1]) // [i, [[a], [d], [c]]]
                    : change[1].apply(originalObject); // [i, Diff]
        });

        return out;
    }

    /**
        Returns a new `Diff` that reverts the changes made by this one. If `apply` is called on
        the returned `Diff` passing the `second` argument used to construct `this`, then and object
        identical to the `first` argument used to construct `this` will be returned by `apply`.
    **/
    public function swap():Diff {
        final additions = this.d;
        final deletions = this.a;
        final changes = new StringMap<Dynamic>();
        final changedKeys = [for (k in this.c.keys()) k];
        Lambda.iter(changedKeys, function(k) {
            final change = this.c.get(k);
            if (Std.isOfType(change, Array)) {
                if (change.length == 2) {
                    // [old, new]
                    changes.set(k, [cast(change, Array<Dynamic>)[1], cast(change, Array<Dynamic>)[0]]);
                } else {
                    // [[a], [d], [c]]
                    changes.set(k, swapArray(change));
                }
            } else {
                // Diff
                changes.set(k, change.swap());
            }
        });

        final diff = Type.createEmptyInstance(Diff);
        Reflect.setField(diff, 'a', additions);
        Reflect.setField(diff, 'd', deletions);
        Reflect.setField(diff, 'c', changes);
        return diff;
    }

    private static function swapArray(arr:Array<Array<Dynamic>>):Array<Array<Dynamic>> {
        final additions = arr[1];
        final deletions = arr[0];
        final changes = arr[2];
        final swappedChanges: Array<Array<Dynamic>> = changes.map(function(change: Array<Dynamic>) {
            final i: Dynamic = change[0];
            final first: Dynamic = change[1];
            final second: Dynamic = change[2];
            final swappedChange: Array<Dynamic> =
                (change.length == 3) ?
                    [i, second, first]
                : (Std.isOfType(first, Array)) ?
                    [i, swapArray(first)]
                :
                    [i, first.swap()];
            return swappedChange;
        });

        return [
            additions,
            deletions,
            swappedChanges
        ];
    }

    /**
        Returns a string with the Json representation of `this` `Diff`.
    **/
    public function toString():String {
        return haxe.Json.stringify(this.toObject());
    }

    private function toObject():Dynamic {
        final obj = {
            a: mapToObject(this.a),
            d: mapToObject(this.d),
            c: {}
        };
        final changedKeys = [for (k in this.c.keys()) k];
        Lambda.iter(changedKeys, function(key) {
            final value = this.c.get(key);
            if (Std.isOfType(value, Diff)) {
                // Diff
                Reflect.setField(obj.c, key, value.toObject());
            } else if (isArray(value) && value.length == 3) {
                // [[a], [d], [c]]
                Reflect.setField(obj.c, key, changeArrayToObject(value));
            } else {
                // [old, new]
                Reflect.setField(obj.c, key, value);
            }
        });
        return obj;
    }

    private static function mapToObject(map:StringMap<Dynamic>):Dynamic {
        final keys = [for (k in map.keys()) k];
        final obj = {};
        Lambda.iter(keys, key -> Reflect.setField(obj, key, map.get(key)));
        return obj;
    }

    private static function changeArrayToObject(arr:Array<Array<Dynamic>>):Array<Array<Dynamic>> {
        final changesList = Lambda.map(arr[2], function(el:Array<Dynamic>):Array<Dynamic> {
            if (Std.isOfType(el[1], Diff)) {
                return [el[0], el[1].toObject()];
            } else if (isArray(el[1])) {
                return [el[0], changeArrayToObject(untyped el[1])];
            } else {
                return el;
            }
        });
        final changes = [for (change in changesList) change];
        final arr = [
            arr[0],
            arr[1],
            changes
        ];
        return arr;
    }
}
