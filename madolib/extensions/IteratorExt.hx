package madolib.extensions;

import madolib.Option;

class IteratorExt {
    public inline static function isEmpty<T>(self: Iterator<T>): Bool
        return !self.hasNext();

    public inline static function any<T>(self: Iterator<T>, predicate: T -> Bool): Bool {
        var result = false;
        for(x in self) {
            if(predicate(x)) {
                result = true;
                break;
            }
        }
        return result;
    }

    public inline static function all<T>(self: Iterator<T>, predicate: T -> Bool): Bool {
        var result = true;
        for(x in self) {
            if(!predicate(x)) {
                result = false;
                break;
            }
        }
        return result;
    }

    public inline static function find<T>(self: Iterator<T>, predicate: T -> Bool): Null<T> {
        var element: Null<T> = null;
        for(x in self) {
            if(predicate(x)) {
                element = x;
                break;
            }
        }
        return element;
    }

    public inline static function findOption<T>(self: Iterator<T>, predicate: T -> Bool): Option<T> {
        var element = None;
        for(x in self) {
            if(predicate(x)) {
                element = Some(x);
                break;
            }
        }
        return element;
    }

    public inline static function at<T>(self: Iterator<T>, index: Int): Option<T> {
        return if(index < 0) {
            None;
        } else {
            var element = None;
            var pos = 0;
            for(x in self) {
                if(pos++ == index) {
                    element = Some(x);
                    break;
                }
            }
            element;
        }
    }

    public inline static function filter<T>(self: Iterator<T>, predicate: T -> Bool): Array<T> {
        final result: Array<T> = [];
        for(x in self) {
            if(predicate(x))
                result.push(x);
        }
        return result;
    }

    public inline static function filterNull<T>(self: Iterator<Null<T>>): Array<T> {
        final result: Array<T> = [];
        for(x in self) {
            if(x != null)
                result.push(x);
        }
        return result;
    }

    public inline static function filterOption<T>(self: Iterator<Option<T>>): Array<T> {
        final result = [];
        for(x in self) {
            switch(x) {
                case None:
                case Some(x):
                    result.push(x);
            }
        }
        return result;
    }

    public inline static function each<T>(self: Iterator<T>, action: T -> Void) {
        while(self.hasNext())
            action(self.next());
    }

    public inline static function eachi<T>(self: Iterator<T>, action: Int -> T -> Void) {
        var i = 0;
        while(self.hasNext())
            action(i++, self.next());
    }

    public inline static function map<T, R>(self: Iterator<T>, f: T -> R): Array<R> {
        final result = [];
        for(x in self)
            result.push(f(x));
        return result;
    }

    public inline static function mapi<T, R>(self: Iterator<T>, f: Int -> T -> R): Array<R> {
        final result = [];
        var i = 0;
        for(x in self)
            result.push(f(i++, x));
        return result;
    }

    public inline static function reduce<T, Acc>(self: Iterator<T>, init: Acc, callback: Acc -> T -> Acc): Acc {
        while(self.hasNext())
            init = callback(init, self.next());
        return init;
    }

    public inline static function reducei<T, Acc>(self: Iterator<T>, init: Acc, callback: Acc -> Int -> T -> Acc): Acc {
        var i = 0;
        while(self.hasNext())
            init = callback(init, i++, self.next());
        return init;
    }

    public inline static function first<T>(self: Iterator<T>, ?predicate: T -> Bool): Option<T>
        return if(predicate != null) findOption(self, predicate) else if(self.hasNext()) Some(self.next()) else None;

    public inline static function last<T>(self: Iterator<T>, ?predicate: T -> Bool): Option<T> {
        var element = None;
        if(predicate != null) {
            for(v in self) {
                if(!predicate(v))
                    continue;
                element = Some(v);
            }
        } else {
            while(self.hasNext())
                element = Some(self.next());
        }
        return element;
    }

    public inline static function indexOf<T>(self: Iterator<T>, element: T): Int {
        var index = -1;
        var pos = 0;
        for(v in self) {
            if(DynamicExt.equals(v, element)) {
                index = pos;
                break;
            }
            pos++;
        }
        return index;
    }

    public inline static function reversed<T>(self: Iterator<T>): Array<T> {
        final result = [];
        for(v in self)
            result.push(v);
        result.reverse();
        return result;
    }

    public inline static function takeUntil<T>(self: Iterator<T>, f: T -> Bool): Array<T> {
        final result = [];
        for(v in self) {
            if(!f(v))
                break;
            result.push(v);
        }
        return result;
    }

    public inline static function dropUntil<T>(self: Iterator<T>, f: T -> Bool): Array<T> {
        var done = false;
        final result = [];
        for(v in self) {
            if(done) {
                result.push(v);
                continue;
            }
            if(f(v))
                continue;
            done = true;
            result.push(v);
        }
        return result;
    }

    public inline static function unzip<T1, T2>(self: Iterator<Tuple<T1, T2>>): Tuple<Array<T1>, Array<T2>> {
        final r1 = [], r2 = [];
        for(x in self) {
            r1.push(x.left);
            r2.push(x.right);
        }
        return new Tuple(r1, r2);
    }

    public inline static function zip<T1, T2>(self: Iterator<T1>, it: Iterator<T2>): Array<Tuple<T1, T2>> {
        final result = [];
        while(self.hasNext() && it.hasNext())
            result.push(new Tuple(self.next(), it.next()));
        return result;
    }

    public inline static function toArray<T>(self: Iterator<T>): Array<T>
        return [for(x in self) x];

    @SuppressWarnings("checkstyle:Dynamic")
    public inline static function isIterator(v: Dynamic): Bool {
        final c = Type.getClass(v);
        return if(c == null) {
            false;
        } else {
            final fields = if(TypeExt.isAnonymousObject(v)) Reflect.fields(v) else Type.getInstanceFields(c);
            return if(!Lambda.has(fields, "next") || !Lambda.has(fields, "hasNext")) {
                false;
            } else {
                Reflect.isFunction(Reflect.field(v, "next")) && Reflect.isFunction(Reflect.field(v, "hasNext"));
            }
        }
    }
}
