/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.util;


/**
    A Collection is a way to have a standard collection type across all languages supported by the
    SDK.
**/
#if javalib
class Collection<T> extends Base implements java.lang.Iterable<T> {
#else
class Collection<T> extends Base {
#end
    /**
        Creates a new Collection.
    **/
    public function new() {
        this._array = new Array<T>();
    }


    /**
        The length of `this` Collection.
    **/
    public function length(): Int {
        return this._array.length;
    }


    /**
        Returns the element at the specified index.
    **/
    public function get(index: Int): T {
        return this._array[index];
    }


    /**
        Sets the value of the element at the specified index.
    **/
    public function set(index: Int, x: T): Collection<T> {
        this._array[index] = x;
        return this;
    }


    /**
        Returns a Haxe array with the same elements as the collection.

        The array is a shallow copy of the original collection.

        This can be used when using the SDK within Haxe, but it is likely useless
        on other target languages.
    **/
    public function toArray(): Array<T> {
        return this._array.copy();
    }


    /**
        Returns a new Collection by appending the elements of `c` to the elements of
        `this` Collection.

        This operation does not modify `this` Collection.

        If `c` is an empty collection, a copy of `this` Collection is returned.

        The length of the returned Collection is equal to the sum of `this.length()`
        and `c.length()`.

        If `c` is `null`, the result is unspecified.
    **/
    public function concat(c: Collection<T>): Collection<T> {
        return Collection._fromArray(this._array.concat(c._array));
    }


    /**
        Returns a shallow copy of `this` Collection.

        The elements are not copied and retain their identity, so
        `c.get(i) == c.copy().get(i)` is true for any valid `i`. However,
        `c == c.copy()` is always false.
    **/
    public function copy(): Collection<T> {
        return Collection._fromArray(this._array.copy());
    }


    /**
        Returns position of the first occurrence of `x` in `this` Collection, searching front to back.

        - If `x` is found by checking standard equality, the function returns its index.
        - If `x` is not found, the function returns -1.
        - If `fromIndex` is specified, it will be used as the starting index to search from,
        otherwise search starts with zero index. If it is negative, it will be taken as the
        offset from the end of `this` Collection to compute the starting index. If given or computed
        starting index is less than 0, the whole collection will be searched, if it is greater than
        or equal to the length of `this` Collection, the function returns -1.
    **/
    public function indexOf(x: T, ?fromIndex: Int): Int {
        return this._array.indexOf(x, fromIndex);
    }


    /**
        Inserts the element `x` at the position `pos`.
        This operation modifies `this` Collection in place.
        The offset is calculated like so:
        - If `pos` exceeds `this.length()`, the offset is `this.length()`.
        - If `pos` is negative, the offset is calculated from the end of `this`
          Collection, i.e. `this.length() + pos`. If this yields a negative value, the
          offset is 0.
        - Otherwise, the offset is `pos`.
        If the resulting offset does not exceed `this.length()`, all elements from
        and including that offset to the end of `this` Collection are moved one index
        ahead.
    **/
    public function insert(pos: Int, x: T): Void {
        this._array.insert(pos, x);
    }


    /**
        Returns an iterator of the Collection values. This can be used with `for` loops when
        using the SDK within Haxe, and in Java it returns a native iterator.
    **/
#if javalib
    public function iterator(): java.util.Iterator<T> {
        return new connect.native.JavaIterator(this._array);
    }
#else
    public function iterator(): Iterator<T> {
        return this._array.iterator();
    }
#end


#if python
    private function __iter__(): Dynamic {
        final list: Dynamic = this._array;
        return list.__iter__();
    }
#end


    /**
        Returns a string representation of `this` Collection, with `sep` separating
        each element.

        - If `this` is the empty Collection `[]`, the result is the empty String `""`.
        - If `this` has exactly one element, the result is equal to converting the element to string.
        - If `sep` is null, the result is unspecified.
    **/
    public function join(sep: String): String {
        return this._array.join(sep);
    }


    /**
        Returns position of the last occurrence of `x` in `this` Collection, searching back to
        front.

        - If `x` is found by checking standard equality, the function returns its index.
        - If `x` is not found, the function returns -1.
        - If `fromIndex` is specified, it will be used as the starting index to search from,
        otherwise search starts with the last element index. If it is negative, it will be
        taken as the offset from the end of `this` Collection to compute the starting index. If
        given or computed starting index is greater than or equal to the length of `this`
        Collection, the whole array will be searched, if it is less than 0, the function returns
        -1.
    **/
    public function lastIndexOf(x: T, ?fromIndex: Int): Int {
        return this._array.lastIndexOf(x, fromIndex);
    }


    /**
        Removes the last element of `this` Collection and returns it.

        This operation modifies `this` Collection in place.

        - If `this` has at least one element, `this.length()` will decrease by 1.
        - If `this` is the empty Collection, null is returned and the length remains 0.
    **/
    public function pop(): T {
        return this._array.pop();
    }


    /**
        Adds the element `x` at the end of `this` Collection and returns the new
        length of `this` Collection.

        This operation modifies `this` Collection in place.
        
        `this.length()` increases by 1.

        `this` Collection is returned to allows for fluent programming (method chaining).
    **/
    public function push(x: T): Collection<T> {
        this._array.push(x);
        return this;
    }


    /**
        Removes the first occurrence of `x` in `this` Collection.

        This operation modifies `this` Collection in place.

        If `x` is found by checking standard equality, it is removed from `this`
        Collection and all following elements are reindexed accordingly. The function
        then returns true.

        If `x` is not found, `this` Collection is not changed and the function returns false.
    **/
    public function remove(x: T): Bool {
        return this._array.remove(x);
    }


    /**
        Reverse the order of elements of `this` Collection.

        This operation modifies `this` Collection in place.

        If `this.length() < 2`, `this` remains unchanged.
    **/
    public function reverse(): Void {
        this._array.reverse();
    }


    /**
        Removes the first element of `this` Collection and returns it.

        This operation modifies `this` Collection in place.

        If `this` has at least one element, `this.length()` and the index of each
        remaining element is decreased by 1.

        If `this` is the empty Collection, `null` is returned and the length remains 0.
    **/
    public function shift(): T {
        return this._array.shift();
    }


    /**
        Creates a shallow copy of the range of `this` Collection, starting at and
        including `pos`, up to but not including `end`.

        This operation does not modify `this` Collection.

        The elements are not copied and retain their identity.

        If `end` is omitted or exceeds `this.length()`, it defaults to the end of
        `this` Collection.

        If `pos` or `end` are negative, their offsets are calculated from the
        end of `this` Collection by `this.length() + pos` and `this.length() + end`
        respectively. If this yields a negative value, 0 is used instead.

        If `pos` exceeds `this.length()` or if `end` is less than or equals
        `pos`, the result is an empty Collection.
    **/
    public function slice(pos: Int, ?end: Int): Collection<T> {
        return Collection._fromArray(this._array.slice(pos, end));
    }


    /**
        Removes `len` elements from `this` Collection, starting at and including `pos`,
        and returns them.

        This operation modifies `this` Collection in place.

        If `len` is < 0 or `pos` exceeds `this.length()`, an empty Collection is
        returned and `this` Collection is unchanged.

        If `pos` is negative, its value is calculated from the end    of `this`
        Collection by `this.length() + pos`. If this yields a negative value, 0 is used instead.

        If the sum of the resulting values for `len` and `pos` exceed
        `this.length()`, this operation will affect the elements from `pos` to the
        end of `this` Collection.

        The length of the returned Collection is equal to the new length of `this`
        Collection subtracted from the original length of `this` Collection. In other
        words, each element of the original `this` Collection either remains in
        `this` Collection or becomes an element of the returned Collection.
    **/
    public function splice(pos: Int, len: Int): Collection<T> {
        return Collection._fromArray(this._array.splice(pos, len));
    }


    /**
        Returns a string representation of `this` Collection.

        The result will include the individual elements' String representations
        separated by comma. The enclosing [ ] may be missing on some platforms.
    **/
    public function toString(): String {
        return this._array.toString();
    }


    /**
        Adds the element `x` at the start of `this` Collection.

        This operation modifies `this` Collection in place.

        `this.length()` and the index of each Collection element increases by 1.
    **/
    public function unshift(x: T): Collection<T> {
        this._array.unshift(x);
        return this;
    }


    @:dox(hide)
    public static function _fromArray<T>(array: Array<T>) {
        var col = new Collection();
        col._array = array.copy();
        return col;
    }


    private var _array: Array<T>;
}
