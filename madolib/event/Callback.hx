package madolib.event;

/**
 * Implementation based on
 * https://github.com/haxetink/tink_core/blob/master/src/tink/core/Callback.hx
 */
abstract Callback<T>(T -> Void) from T -> Void {
    inline function new(f: T -> Void)
        this = f;

    @:to inline function toFunction(): T -> Void
        return this;

    static var depth = 0;
    static final maxDepth = 500;

    public inline static function guardStackoverflow(fn: () -> Void)
        if(depth < maxDepth) {
            depth += 1;
            fn();
            depth -= 1;
        } else {
            Callback.defer(fn);
        }

    public inline function invoke(data: T)
        guardStackoverflow(() -> this(data));

    public inline static function defer(f: () -> Void) {
        #if macro
        f();
        #else
        haxe.Timer.delay(f, 0);
        #end
    }
}
