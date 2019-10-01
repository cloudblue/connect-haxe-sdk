package connect;

#if java
typedef Arr<T> = java.NativeArray<T>;
#else
typedef Arr<T> = Array<T>;
#end


class Collection<T> {
    public function new(?array: Array<T>) {
        if (array != null) {
            this._array = array.copy();
        } else {
            this._array = new Array<T>();
        }
    }


    public function length(): Int {
        return this._array.length;
    }


    public function get(index: Int): T {
        return this._array[index];
    }


    public function set(index: Int, x: T): Collection<T> {
        this._array[index] = x;
        return this;
    }


    public function toArray(): Arr<T> {
#if java
        var arr = new Arr<T>(this._array.length);
        for (i in 0...arr.length) {
            arr[i] = this._array[i];
        }
        return arr;
#else
        return this._array.copy();
#end
    }


    public function concat(c: Collection<T>): Collection<T> {
        return new Collection<T>(this._array.concat(c._array));
    }


    public function copy(): Collection<T> {
        return new Collection<T>(this._array.copy());
    }


    public function indexOf(x: T, ?fromIndex: Int): Int {
        return this._array.indexOf(x, fromIndex);
    }


    public function insert(pos: Int, x: T): Void {
        this._array.insert(pos, x);
    }


    public function iterator(): Iterator<T> {
        return this._array.iterator();
    }


    public function join(sep: String): String {
        return this._array.join(sep);
    }


    public function lastIndexOf(x: T, ?fromIndex: Int): Int {
        return this._array.lastIndexOf(x, fromIndex);
    }


    public function pop(): T {
        return this._array.pop();
    }


    public function push(x: T): Collection<T> {
        this._array.push(x);
        return this;
    }


    public function remove(x: T): Bool {
        return this._array.remove(x);
    }


    public function reverse(): Void {
        this._array.reverse();
    }


    public function shift(): T {
        return this._array.shift();
    }


    public function slice(pos: Int, ?end: Int): Collection<T> {
        return new Collection<T>(this._array.slice(pos, end));
    }


    public function splice(pos: Int, len: Int): Collection<T> {
        return new Collection<T>(this._array.splice(pos, len));
    }


    public function toString(): String {
        return this._array.toString();
    }


    public function unshift(x: T): Collection<T> {
        this._array.unshift(x);
        return this;
    }


    private var _array: Array<T>;
}
