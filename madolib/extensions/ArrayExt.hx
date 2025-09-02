package madolib.extensions;

import haxe.ds.ArraySort;
import madolib.Option;

using madolib.extensions.ArrayExt;

class ArrayExt {
    public inline static function fastInsert<T>(self: Array<T>, index: Int, value: T) {
        if(index >= self.length - 1) {
            self[self.length] = value;
        } else {
            self.insert(index, value);
        }
    }

    public inline static function isEmpty<T>(self: Array<T>): Bool
        return self.length == 0;

    public inline static function inBounds<T>(self: Array<T>, index: Int): Bool
        return index >= 0 && index < self.length;

    public inline static function at<T>(self: Array<T>, index: Int): Option<T>
        return if(self.inBounds(index)) Some(self[index]) else None;

    public inline static function reversed<T>(self: Array<T>): Array<T>
        return if(self.length < 2) {
            self;
        } else {
            final result = self.copy();
            result.reverse();
            result;
        }

    public inline static function sorted<T>(self: Array<T>, cmp: T -> T -> Int): Array<T>
        return if(self.length < 2) {
            self;
        } else {
            final result = self.copy();
            ArraySort.sort(result, cmp);
            result;
        }

    public inline static function mapi<T, R>(self: Array<T>, f: Int -> T -> R): Array<R>
        return [for(i in 0...self.length) f(i, self[i])];

    public inline static function each<T>(self: Array<T>, f: T -> Void) {
        for(x in self)
            f(x);
    }

    public inline static function eachi<T>(self: Array<T>, f: Int -> T -> Void) {
        for(i in 0...self.length)
            f(i, self[i]);
    }

    public inline static function reduce<T, Acc>(self: Array<T>, init: Acc, f: Acc -> T -> Acc): Acc {
        for(x in self)
            init = f(init, x);
        return init;
    }

    public inline static function reducei<T, Acc>(self: Array<T>, init: Acc, f: Acc -> Int -> T -> Acc): Acc {
        for(i in 0...self.length)
            init = f(init, i, self[i]);
        return init;
    }

    public inline static function flatten<T>(self: Array<Array<T>>): Array<T> {
        #if js
        return untyped __js__("Array.prototype.concat.apply")([], self);
        #else
        return reduce(self, [], (acc, elem) -> acc.concat(elem));
        #end
    }

    public inline static function flatMap<T, R>(self: Array<T>, f: T -> Array<R>): Array<R>
        return flatten(self.map(f));

    public inline static function forEach<T>(self: Array<T>, f: T -> Bool): Bool {
        var result = true;
        for(x in self) {
            if(!f(x)) {
                result = false;
                break;
            }
        }
        return result;
    }

    public inline static function any<T>(self: Array<T>, predicate: T -> Bool): Bool {
        var result = false;
        for(x in self) {
            if(predicate(x)) {
                result = true;
                break;
            }
        }
        return result;
    }

    public inline static function all<T>(self: Array<T>, predicate: T -> Bool): Bool
        return forEach(self, predicate);

    @:generic
    public inline static function find<T>(self: Array<T>, f: T -> Bool): Null<T> @:nullSafety(Off) {
        var result: Null<T> = null;
        for(x in self) {
            if(f(x)) {
                result = x;
                break;
            }
        }
        return result;
    }

    public inline static function findOption<T>(self: Array<T>, f: T -> Bool): Option<T> {
        final value = find(self, f);
        return if(value != null) Some(value) else None;
    }

    public inline static function filterNull<T>(self: Array<Null<T>>): Array<T>
        return [for(x in self) if(x != null) x];

    public inline static function filterNone<T>(self: Array<Option<T>>): Array<T> {
        final result = [];
        for(x in self) {
            switch x {
                case Some(v): result.push(v);
                case None:
            }
        }
        return result;
    }

    public inline static function removeByFirst<T>(self: Array<T>, equal: T -> Bool): Array<T> {
        final result = self.copy();
        result.fastRemoveByFirst(equal);
        return result;
    }

    public inline static function fastRemoveByFirst<T>(self: Array<T>, equal: T -> Bool): Array<T> {
        var i = 0;
        while(i < self.length) {
            if(equal(self[i])) {
                self.splice(i, 1);
                break;
            }
            i++;
        }
        return self;
    }

    public inline static function removeByLast<T>(self: Array<T>, equal: T -> Bool): Array<T> {
        final result = self.copy();
        result.fastRemoveByLast(equal);
        return result;
    }

    public inline static function fastRemoveByLast<T>(self: Array<T>, equal: T -> Bool): Array<T> {
        var i = self.length - 1;
        while(i >= 0) {
            if(equal(self[i])) {
                self.splice(i, 1);
                break;
            }
            i--;
        }
        return self;
    }

    public inline static function removeAll<T>(self: Array<T>, value: T): Array<T> {
        final result = self.copy();
        var i = 0;
        while(i < result.length) {
            if(result[i] == value) {
                result.splice(i, 1);
            } else {
                i++;
            }
        }
        return result;
    }

    public inline static function fastRemoveAll<T>(self: Array<T>, value: T): Array<T> {
        while(self.remove(value)) {}
        return self;
    }

    public inline static function removeAt<T>(self: Array<T>, index: Int): Array<T>
        return switch index {
            case n if(self.inBounds(n)):
                final result = self.copy();
                result.splice(n, 1);
                result;
            default: self;
        }

    public inline static function fastRemoveAt<T>(self: Array<T>, index: Int): Array<T>
        return switch index {
            case n if(self.inBounds(n)):
                self.splice(n, 1);
                self;
            default: self;
        }

    public inline static function removeBy<T>(self: Array<T>, equal: T -> Bool): Array<T> {
        final result = self.copy();
        var i = 0;
        while(i < result.length) {
            if(equal(result[i])) {
                result.splice(i, 1);
            } else {
                i++;
            }
        }
        return result;
    }

    public inline static function fastRemoveBy<T>(self: Array<T>, equal: T -> Bool): Array<T> {
        var i = 0;
        while(i < self.length) {
            if(equal(self[i])) {
                self.splice(i, 1);
            } else {
                i++;
            }
        }
        return self;
    }

    public inline static function compare<T>(self: Array<T>, other: Array<T>): Int {
        var v = 0;
        if((v = IntExt.compare(self.length, other.length)) == 0) {
            for(i in 0...self.length) {
                if((v = DynamicExt.compare(self[i], other[i])) != 0)
                    break;
            }
        }
        return v;
    }

    public inline static function string<T>(self: Array<T>): String
        return '[${self.map(DynamicExt.string).join(", ")}]';

    public inline static function cross<T>(self: Array<T>, other: Array<T>): Array<Array<T>>
        return [for(x in self)for(y in other) [x, y]];

    public inline static function first<T>(self: Array<T>, ?predicate: T -> Bool): Option<T>
        return if(self.isEmpty()) {
            None;
        } else if(predicate == null) {
            Some(self[0]);
        } else {
            var result = None;
            for(x in self) {
                if(predicate(x)) {
                    result = Some(x);
                    break;
                }
            }
            result;
        }

    public inline static function last<T>(self: Array<T>, ?predicate: T -> Bool): Option<T>
        return if(self.isEmpty()) {
            None;
        } else if(predicate == null) {
            Some(self[self.length - 1]);
        } else {
            var result = None;
            var i = self.length;
            while(--i >= 0) {
                if(predicate(self[i])) {
                    result = Some(self[i]);
                    break;
                }
            }
            result;
        }

    public inline static function intersperse<T>(self: Array<T>, value: T): Array<T>
        return if(self.isEmpty()) {
            [];
        } else {
            final result = [self[0]];
            for(i in 1...self.length) {
                result.push(value);
                result.push(self[i]);
            }
            return result;
        }

    public inline static function intersperseLazy<T>(self: Array<T>, f: () -> T): Array<T>
        return if(self.isEmpty()) {
            [];
        } else {
            final result = [self[0]];
            for(i in 1...self.length) {
                result.push(f());
                result.push(self[i]);
            }
            return result;
        }

    public inline static function take<T>(self: Array<T>, n: Int): Array<T>
        return self.slice(0, n);

    public inline static function drop<T>(self: Array<T>, n: Int): Array<T>
        return if(n >= self.length) [] else self.slice(n, self.length);

    public inline static function takeUntil<T>(self: Array<T>, f: T -> Bool): Array<T> {
        final result = [];
        for(v in self) {
            if(!f(v)) break;
            result.push(v);
        }
        return result;
    }

    public inline static function dropUntil<T>(self: Array<T>, f: T -> Bool): Array<T> {
        var done = false;
        final result = [];
        for(v in self) {
            if(done) {
                result.push(v);
                continue;
            }
            if(f(v)) continue;
            done = true;
            result.push(v);
        }
        return result;
    }

    public inline static function average<T: Float>(self: Array<T>): Float
        return if(self.length == 0) {
            0.;
        } else {
            self.reduce(0., (acc, n) -> acc + n) / self.length;
        }

    public inline static function unique<T>(self: Array<T>): Array<T> {
        final result: Array<T> = [];
        for(x in self) {
            if(result.find(y -> DynamicExt.equals(x, y)) == null)
                result.push(x);
        }
        return result;
    }

    extern overload public inline static function maxBy<T>(self: Array<T>, ord: Ord<T>): Option<T>
        return if(self.isEmpty()) {
            None;
        } else if(self.length == 1) {
            Some(self[0]);
        } else {
            Some(self.reduce(self[1], ord.max));
        }

    extern overload public inline static function maxBy<T>(self: Array<T>, compare: T -> T -> Int): Option<T>
        return if(self.isEmpty()) {
            None;
        } else if(self.length == 1) {
            Some(self[0]);
        } else {
            Some(self.reduce(self[1], (acc, n) -> if(compare(acc, n) < 0) n else acc));
        }

    extern overload public inline static function minBy<T>(self: Array<T>, ord: Ord<T>): Option<T>
        return if(self.isEmpty()) {
            None;
        } else if(self.length == 1) {
            Some(self[0]);
        } else {
            Some(self.reduce(self[1], ord.min));
        }

    extern overload public inline static function minBy<T>(self: Array<T>, compare: T -> T -> Int): Option<T>
        return if(self.isEmpty()) {
            None;
        } else if(self.length == 1) {
            Some(self[0]);
        } else {
            Some(self.reduce(self[1], (acc, n) -> if(compare(acc, n) > 0) n else acc));
        }

    extern overload public inline static function maxValue<T, R: Float>(self: Array<T>, mapper: T -> R): Option<T>
        return maxBy(self, (a, b) -> FloatExt.compare(mapper(a), mapper(b)));

    extern overload public inline static function maxValue<T>(self: Array<T>, mapper: T -> String): Option<T>
        return maxBy(self, (a, b) -> StringExt.compare(mapper(a), mapper(b)));

    extern overload public inline static function minValue<T, R: Float>(self: Array<T>, mapper: T -> R): Option<T>
        return minBy(self, (a, b) -> FloatExt.compare(mapper(a), mapper(b)));

    extern overload public inline static function minValue<T>(self: Array<T>, mapper: T -> String): Option<T>
        return minBy(self, (a, b) -> StringExt.compare(mapper(a), mapper(b)));

    public inline static function max<T: Float>(self: Array<T>): Option<T>
        return minValue(self, x -> x);

    public inline static function min<T: Float>(self: Array<T>): Option<T>
        return maxValue(self, x -> x);

    public inline static function zip<T1, T2>(self: Array<T1>, other: Array<T2>): Array<Tuple<T1, T2>> {
        final length = Math.min(self.length, other.length);
        return [for(i in 0...length) Tuple.of(self[i], other[i])];
    }

    public inline static function unzip<T1, T2>(self: Array<Tuple<T1, T2>>): Tuple<Array<T1>, Array<T2>> {
        final r1 = [];
        r1.resize(self.length);
        final r2 = [];
        r2.resize(self.length);
        for(i => t in self) {
            r1[i] = t.left;
            r2[i] = t.right;
        }
        return Tuple.of(r1, r2);
    }

    public inline static function sample<T>(self: Array<T>, ?random: Random): T
        return (random ?? Random.gen).choice(self);

    public inline static function shuffle<T>(self: Array<T>, ?random: Random): Array<T>
        return (random ?? Random.gen).shuffle(self);

    inline static function scoreSort<T: {score: Float}>(self: Array<T>, isAscent: Bool = true): Array<T>
        return self.sorted((x, y) -> if(isAscent) FloatExt.compare(x.score, y.score) else FloatExt.compare(y.score, x.score));

    inline static function toScoredArray<T>(self: Array<T>, scoreElement: T -> Float): Array<{item: T, score: Float}>
        return self.map(x -> {
            item: x,
            score: scoreElement(x),
        });

    public inline static function findBestValue<T>(self: Array<T>, scoreElement: T -> Float): Option<T>
        return if(self.length == 0) None else Some(self.toScoredArray(scoreElement).scoreSort()[self.length - 1].item);

    public inline static function findNearestValue<T>(self: Array<T>, targetScore: Float, scoreElement: T -> Float): Option<T>
        return if(self.length == 0) None else Some(self.toScoredArray(x -> Math.abs(scoreElement(x) - targetScore)).scoreSort()[0].item);

    public inline static function findNearestValues<T>(self: Array<T>, targetScore: Float, scoreElement: T -> Float): Array<T>
        return if(self.length == 0) {
            [];
        } else {
            final arr = self.toScoredArray(x -> Math.abs(scoreElement(x) - targetScore)).scoreSort();
            final minScore = arr[0].score;
            return [for(x in arr) {
                if(x.score > minScore) break;
                x.item;
            }];
        }
}

class IntArrayExt {
    public inline static function sum(self: Array<Int>): Int
        return self.reduce(0, (acc, n) -> acc + n);
}

class FloatArrayExt {
    public inline static function sum(self: Array<Float>): Float
        return self.reduce(0., (acc, n) -> acc + n);
}
