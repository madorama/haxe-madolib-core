package madolib;

import hxmath.math.IntVector2;

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
}
