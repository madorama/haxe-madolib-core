package madolib;

@:using(madolib.Ord.OrderingExt)
private enum OrderingImpl {
    LT;
    GT;
    EQ;
}

abstract Ordering(OrderingImpl) from OrderingImpl to OrderingImpl {
    public inline static function fromInt(value: Int): Ordering
        return if(value < 0) LT else if(value > 0) GT else EQ;

    public inline static function fromFloat(value: Float): Ordering
        return if(value < 0) LT else if(value > 0) GT else EQ;

    public inline function toInt(): Int
        return switch this {
            case LT: -1;
            case GT: 1;
            case EQ: 0;
        }
}

class OrderingExt {
    public inline static function negate(o: Ordering): Ordering
        return switch o {
            case LT: GT;
            case EQ: EQ;
            case GT: LT;
        }
}

abstract Ord<A>(A -> A -> Ordering) from A -> A -> Ordering to A -> A -> Ordering {
    public inline function order(a: A, b: A): Ordering
        return this(a, b);

    public inline function max(a: A, b: A): A
        return switch this(a, b) {
            case LT | EQ: b;
            case GT: a;
        }

    public inline function min(a: A, b: A): A
        return switch this(a, b) {
            case LT | EQ: a;
            case GT: b;
        }

    public inline function equal(a: A, b: A): Bool
        return this(a, b) == EQ;

    public inline function inverse(): Ord<A>
        return (a, b) -> this(b, a);
}
