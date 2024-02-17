package madolib;

private class LazyImpl<T> {
    var _value: Null<T> = null;

    final factory: () -> T;

    public var value(get, set): T;

    inline function get_value(): T {
        if(_value == null) {
            _value = factory();
        }
        return _value;
    }

    inline function set_value(value: T): T {
        return _value = value;
    }

    public function new(factory: () -> T) {
        this.factory = factory;
    }

    inline function toString(): String {
        return '${_value}';
    }
}

abstract Lazy<T>(LazyImpl<T>) {
    public inline function new(factory: () -> T)
        this = new LazyImpl(factory);

    @:to function to(): T {
        return this.value;
    }
}
