package madolib.geom;

import hxmath.math.Vector2;

@:structInit
class Bounds {
    public var x: Float;
    public var y: Float;
    public var width: Float;
    public var height: Float;

    public var left(get, never): Float;
    public var top(get, never): Float;
    public var right(get, never): Float;
    public var bottom(get, never): Float;

    inline function get_left(): Float
        return x;

    inline function get_top(): Float
        return y;

    inline function get_right(): Float
        return x + width;

    inline function get_bottom(): Float
        return y + height;

    public var area(get, never): Float;

    inline function get_area(): Float
        return width * height;

    public var center(get, never): Vector2;

    inline function get_center(): Vector2
        return new Vector2(x + width * .5, y + height * .5);

    public function new(x: Float, y: Float, width: Float, height: Float) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public inline static function fromPoints(a: Vector2, b: Vector2): Bounds
        return new Bounds(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(b.x - a.x), Math.abs(b.y - a.y));

    public inline function set(newX: Float, newY: Float, newWidth: Float, newHeight: Float) {
        x = newX;
        y = newY;
        width = newWidth;
        height = newHeight;
    }

    public inline function equals(b: Bounds): Bool
        return x == b.x && y == b.y && width == b.width && height == b.height;

    public inline function clone(): Bounds
        return new Bounds(x, y, width, height);

    public inline function overlaps(b: Bounds): Bool
        return !(left > b.right || top > b.bottom || right < b.left || bottom < b.top);

    public inline function contains(p: Vector2): Bool
        return p.x >= left && p.x < right && p.y >= top && p.y < bottom;

    public inline function intersection(b: Bounds): Bounds {
        final t = clone();
        if(x < b.x) {
            t.width -= b.x - x;
            x = b.x;
        }
        if(y < b.y) {
            t.height -= b.y - y;
            y = b.y;
        }
        if(right > b.right)
            t.width -= right - b.right;
        if(bottom > b.bottom)
            t.height -= bottom - b.bottom;
        return t;
    }

    public inline function toString(): String
        return '{{${x},${y}},{${width},${height}}}';
}
