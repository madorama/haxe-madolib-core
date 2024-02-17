package madolib.extensions;

import madolib.Option;

class IterableExt {
    public inline static function isEmpty<T>(self: Iterable<T>): Bool
        return IteratorExt.isEmpty(self.iterator());

    public inline static function all<T>(self: Iterable<T>, predicate: T -> Bool): Bool
        return IteratorExt.all(self.iterator(), predicate);

    public inline static function any<T>(self: Iterable<T>, predicate: T -> Bool): Bool
        return IteratorExt.any(self.iterator(), predicate);

    public inline static function find<T>(self: Iterable<T>, predicate: T -> Bool): Null<T>
        return @:nullSafety(Off) IteratorExt.find(self.iterator(), predicate);

    public inline static function findOption<T>(self: Iterable<T>, predicate: T -> Bool): Option<T>
        return IteratorExt.findOption(self.iterator(), predicate);

    public inline static function at<T>(self: Iterable<T>, index: Int): Option<T>
        return IteratorExt.at(self.iterator(), index);

    public inline static function filter<T>(self: Iterable<T>, predicate: T -> Bool): Array<T>
        return IteratorExt.filter(self.iterator(), predicate);

    public inline static function filterNull<T>(self: Iterable<Null<T>>): Array<T>
        return IteratorExt.filterNull(self.iterator());

    public inline static function filterOption<T>(self: Iterable<Option<T>>): Array<T>
        return IteratorExt.filterOption(self.iterator());

    public inline static function each<T>(self: Iterable<T>, action: T -> Void) {
        IteratorExt.each(self.iterator(), action);
    }

    public inline static function eachi<T>(self: Iterable<T>, action: Int -> T -> Void) {
        IteratorExt.eachi(self.iterator(), action);
    }

    public inline static function map<T, R>(self: Iterable<T>, f: T -> R): Array<R>
        return IteratorExt.map(self.iterator(), f);

    public inline static function mapi<T, R>(self: Iterable<T>, f: Int -> T -> R): Array<R>
        return IteratorExt.mapi(self.iterator(), f);

    public inline static function reduce<T, Acc>(self: Iterable<T>, init: Acc, callback: Acc -> T -> Acc): Acc
        return IteratorExt.reduce(self.iterator(), init, callback);

    public inline static function reducei<T, Acc>(self: Iterable<T>, init: Acc, callback: Acc -> Int -> T -> Acc): Acc
        return IteratorExt.reducei(self.iterator(), init, callback);

    public inline static function first<T>(self: Iterable<T>, ?predicate: T -> Bool): Option<T>
        return IteratorExt.first(self.iterator(), predicate);

    public inline static function last<T>(self: Iterable<T>, ?predicate: T -> Bool): Option<T>
        return IteratorExt.last(self.iterator(), predicate);

    public inline static function indexOf<T>(self: Iterable<T>, element: T): Int
        return IteratorExt.indexOf(self.iterator(), element);

    public inline static function reversed<T>(self: Iterable<T>): Array<T>
        return IteratorExt.reversed(self.iterator());

    public inline static function takeUntil<T>(self: Iterable<T>, f: T -> Bool): Array<T>
        return IteratorExt.takeUntil(self.iterator(), f);

    public inline static function dropUntil<T>(self: Iterable<T>, f: T -> Bool): Array<T>
        return IteratorExt.dropUntil(self.iterator(), f);

    public inline static function unzip<T1, T2>(self: Iterable<Tuple<T1, T2>>): Tuple<Array<T1>, Array<T2>>
        return IteratorExt.unzip(self.iterator());

    public inline static function zip<T1, T2>(self: Iterable<T1>, it: Iterable<T2>): Array<Tuple<T1, T2>>
        return IteratorExt.zip(self.iterator(), it.iterator());

    public inline static function toArray<T>(self: Iterable<T>): Array<T>
        return IteratorExt.toArray(self.iterator());

    @SuppressWarnings("checkstyle:Dynamic")
    public inline static function isIterable(v: Dynamic): Bool {
        final c = Type.getClass(v);
        return if(c == null) {
            false;
        } else {
            final fields = if(TypeExt.isAnonymousObject(v)) Reflect.fields(v) else Type.getInstanceFields(c);
            return if(!Lambda.has(fields, "iterator")) {
                false;
            } else {
                Reflect.isFunction(Reflect.field(v, "iterator"));
            }
        }
    }
}
