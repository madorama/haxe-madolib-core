package madolib;

import differ.math.Vector;
import hxmath.math.IntVector2;
import hxmath.math.Vector2;
import madolib.Option.OptionExt;

class Util {
    public inline static function coordToId(x: Int, y: Int, width: Int): Int
        return x + y * width;

    public inline static function idToCoord(index: Int, width: Int): IntVector2
        return new IntVector2(index % width, Std.int(index / width));

    public inline static function tileCoord(x: Float, y: Float, tileWidth: Int, tileHeight: Int): IntVector2
        return new IntVector2(Std.int(x / tileWidth), Std.int(y / tileHeight));

    public inline static function snapGrid(x: Float, y: Float, tileWidth: Int, tileHeight: Int): IntVector2
        return new IntVector2(Std.int(x / tileWidth) * tileWidth, Std.int(y / tileHeight) * tileHeight);

    public inline static function range(start: Int, end: Int): Array<Int> {
        final result = [];
        final step = if(start <= end) 1 else -1;
        var i = start;
        while(if(start <= end) i <= end else end <= i) {
            result.push(i);
            i += step;
        }
        return result;
    }

    public inline static function downcast<T: {}, S: T>(value: T, c: Class<S>): Null<S> {
        #if js
        return if(Std.isOfType(value, c)) {
            cast value;
        } else {
            null;
        }
        #else
        return Std.downcast(value, c);
        #end
    }

    public inline static function tryDowncast<T: {}, S: T>(value: T, c: Class<S>): Option<S>
        return OptionExt.ofValue(downcast(value, c));

    public inline static function toVector(v: Vector2): Vector
        return new Vector(v.x, v.y);

    public inline static function toVector2(v: Vector): Vector2
        return new Vector2(v.x, v.y);
}
