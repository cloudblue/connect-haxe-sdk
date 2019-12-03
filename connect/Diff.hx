package connect;

import haxe.ds.StringMap;


@:dox(hide)
class Diff {
    public final additions: StringMap<Dynamic>;
    public final deletions: StringMap<Dynamic>;
    public final changes: StringMap<Dynamic>;


    public function new(first: Dynamic, second: Dynamic) {
        checkStructs(first, second);
        final firstFields = Reflect.fields(first);
        final secondFields = Reflect.fields(second);
        final addedFields = [for (f in secondFields) if (!Reflect.hasField(first, f)) f];
        final deletedFields = [for (f in firstFields) if (!Reflect.hasField(second, f)) f];
        final commonFields = [for (f in firstFields) if (Reflect.hasField(second, f)) f];
        final changedFields = commonFields.filter(function (f) {
            final a = Reflect.field(first, f);
            final b = Reflect.field(second, f);
            final ta = Type.typeof(a);
            final tb = Type.typeof(b);
            return Std.string(a) != Std.string(b) || Std.string(ta) != Std.string(tb);
        });

        // Set additions
        this.additions = new StringMap<Dynamic>();
        Lambda.iter(addedFields, (f) -> this.additions.set(f, Reflect.field(second, f)));

        // Set deletions
        this.deletions = new StringMap<Dynamic>();
        Lambda.iter(deletedFields, (f) -> this.deletions.set(f, Reflect.field(first, f)));

        // Set changes
        this.changes = new StringMap<Dynamic>();
        Lambda.iter(changedFields, function(f) {
            final a = Reflect.field(first, f);
            final b = Reflect.field(second, f);
            checkSupported(a, b);
            if (isStruct(a) && isStruct(b)) {
                this.changes.set(f, new Diff(a, b));
            } else if (isArray(a) && isArray(b)) {
                this.changes.set(f, parseArrays(a, b));
            } else {
                this.changes.set(f, [a, b]);
            }
        });
    }


    public function toString(): String {
        return haxe.Json.stringify({
            additions: this.additions,
            deletions: this.deletions,
            changes: this.changes
        });
    }


    private static function parseArrays(first: Array<Dynamic>, second: Array<Dynamic>): Array<Array<Dynamic>> {        
        return [first, second];
    }


    private static function isSupported(v: Dynamic): Bool {
        final cls = Type.getClass(v);
        final isSimple = cls == null || Type.getClassName(cls) == null || Std.is(v, String);
        return isSimple || isArray(v) || isStruct(v);
    }


    private static function isArray(v: Dynamic): Bool {
        return Std.is(v, Array);
    }


    private static function isStruct(v: Dynamic): Bool {
        return Type.typeof(v) == TObject;
    }


    private static function checkSupported(first: Dynamic, second: Dynamic): Void {
        if (!isSupported(first) || !isSupported(second)) {
            throw 'Unsupported types in Diff. Values must be primitives, arrays or structs. '
                    + 'Got: ${Type.typeof(first)}, ${Type.typeof(second)}';
        }
    }


    private static function checkStructs(first: Dynamic, second: Dynamic): Void {
        if (!isStruct(first) || !isStruct(second)) {
            throw 'Unsupported types in Diff. Values must be structs. '
                    + 'Got: ${Type.typeof(first)}, ${Type.typeof(second)}';
        }
    }
}
