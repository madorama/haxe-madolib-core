package madolib.extensions;

class FloatExt {
    public inline static function compare(x: Float, y: Float): Int
        return if(x < y) -1 else if(x > y) 1 else 0;

    public static var order(default, never): Ord<Float> = (i0, i1) -> if(i0 > i1) GT else if(i0 == i1) EQ else LT;
}
