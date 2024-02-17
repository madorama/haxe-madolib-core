package madolib;

typedef Tuple<T0, T1> = Tuple2<T0, T1>;

@:structInit
private class Tuple1Impl<T0> {
    final _0: T0;

    public var value(get, never): T0;

    inline function get_value(): T0
        return _0;

    public inline function new(_0: T0)
        this._0 = _0;
}

@:forward(value)
abstract Tuple1<T0>(Tuple1Impl<T0>) from Tuple1Impl<T0> {
    public inline function new(_0: T0)
        this = new Tuple1Impl(_0);

    public inline static function of<T0>(_0: T0): Tuple1<T0>
        return new Tuple1(_0);

    public inline function map<X>(f: T0 -> X): Tuple1<X>
        return new Tuple1(f(this.value));

    public inline function apply<R>(f: T0 -> R): R
        return f(this.value);

    @:op(A == B)
    inline static function equals<T0>(x: Tuple1<T0>, y: Tuple1<T0>): Bool
        return x.value == y.value;

    @:op(A != B)
    inline static function notEquals<T0>(x: Tuple1<T0>, y: Tuple1<T0>): Bool
        return !equals(x, y);

    public inline function toString(): String
        return 'Tuple1(${this.value})';
}

@:structInit
private class Tuple2Impl<T0, T1> {
    final _0: T0;
    final _1: T1;

    public var left(get, never): T0;

    inline function get_left(): T0
        return _0;

    public var right(get, never): T1;

    inline function get_right(): T1
        return _1;

    public inline function new(_0: T0, _1: T1) {
        this._0 = _0;
        this._1 = _1;
    }
}

@:forward(left, right)
abstract Tuple2<T0, T1>(Tuple2Impl<T0, T1>) from Tuple2Impl<T0, T1> {
    public inline function new(_0: T0, _1: T1)
        this = new Tuple2Impl(_0, _1);

    public inline static function of<T0, T1>(_0: T0, _1: T1): Tuple2<T0, T1>
        return new Tuple2(_0, _1);

    public inline function flip(): Tuple2<T1, T0>
        return new Tuple2(this.right, this.left);

    public inline function dropLeft(): Tuple1<T1>
        return new Tuple1(this.right);

    public inline function dropRight(): Tuple1<T0>
        return new Tuple1(this.left);

    public inline function mapFirst<X>(f: T0 -> X): Tuple2<X, T1>
        return mapBoth(f, x -> x);

    public inline function mapSecond<X>(f: T1 -> X): Tuple2<T0, X>
        return mapBoth(x -> x, f);

    public inline function mapBoth<X, Y>(f0: T0 -> X, f1: T1 -> Y): Tuple2<X, Y>
        return new Tuple2(f0(this.left), f1(this.right));

    public inline function apply<R>(f: T0 -> T1 -> R): R
        return f(this.left, this.right);

    @:op(A == B)
    inline static function equals<T0, T1>(x: Tuple2<T0, T1>, y: Tuple2<T0, T1>): Bool
        return x.left == y.left && x.right == y.right;

    @:op(A != B)
    inline static function notEquals<T0, T1>(x: Tuple2<T0, T1>, y: Tuple2<T0, T1>): Bool
        return !equals(x, y);

    public inline function toString(): String
        return 'Tuple2(${this.left}, ${this.right})';
}

@:structInit
private class Tuple3Impl<T0, T1, T2> {
    final _0: T0;
    final _1: T1;
    final _2: T2;

    public var first(get, never): T0;

    inline function get_first(): T0
        return _0;

    public var second(get, never): T1;

    inline function get_second(): T1
        return _1;

    public var third(get, never): T2;

    inline function get_third(): T2
        return _2;

    public inline function new(_0: T0, _1: T1, _2: T2) {
        this._0 = _0;
        this._1 = _1;
        this._2 = _2;
    }
}

@:forward(first, second, third)
abstract Tuple3<T0, T1, T2>(Tuple3Impl<T0, T1, T2>) from Tuple3Impl<T0, T1, T2> {
    public inline function new(_0: T0, _1: T1, _2: T2)
        this = new Tuple3Impl(_0, _1, _2);

    public inline static function of<T0, T1, T2>(_0: T0, _1: T1, _2: T2): Tuple3<T0, T1, T2>
        return new Tuple3(_0, _1, _2);

    public inline function flip(): Tuple3<T2, T1, T0>
        return new Tuple3(this.third, this.second, this.first);

    public inline function dropLeft(): Tuple2<T1, T2>
        return new Tuple2(this.second, this.third);

    public inline function dropRight(): Tuple2<T0, T1>
        return new Tuple2(this.first, this.second);

    public inline function mapFirst<X>(f: T0 -> X): Tuple3<X, T1, T2>
        return mapAll(f, x -> x, x -> x);

    public inline function mapSecond<X>(f: T1 -> X): Tuple3<T0, X, T2>
        return mapAll(x -> x, f, x -> x);

    public inline function mapThird<X>(f: T2 -> X): Tuple3<T0, T1, X>
        return mapAll(x -> x, x -> x, f);

    public inline function mapAll<X, Y, Z>(f0: T0 -> X, f1: T1 -> Y, f2: T2 -> Z): Tuple3<X, Y, Z>
        return new Tuple3(f0(this.first), f1(this.second), f2(this.third));

    public inline function apply<R>(f: T0 -> T1 -> T2 -> R): R
        return f(this.first, this.second, this.third);

    @:op(A == B)
    inline static function equals<T0, T1, T2>(x: Tuple3<T0, T1, T2>, y: Tuple3<T0, T1, T2>): Bool
        return x.first == y.first && x.second == y.second && x.third == y.third;

    @:op(A != B)
    inline static function notEquals<T0, T1, T2>(x: Tuple3<T0, T1, T2>, y: Tuple3<T0, T1, T2>): Bool
        return !equals(x, y);

    public inline function toString(): String
        return 'Tuple3(${this.first}, ${this.second}, ${this.third})';
}
