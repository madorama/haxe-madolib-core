package madolib.extensions;

import haxe.Constraints.IMap;

using madolib.Option.OptionExt;

/**
 * Implementation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Maps.hx
 */
@SuppressWarnings("checkstyle:Dynamic")
class MapExt {
    public inline static function empty<K: Dynamic, V>(): Map<K, V>
        return new Map<K, V>();

    public inline static function mapWithKey<K: Dynamic, V, R>(self: Map<K, V>, f: K -> V -> R): Map<K, R>
        return [for(k => v in self) k => f(k, v)];

    public inline static function mapValues<K: Dynamic, V, R>(self: Map<K, V>, f: V -> R): Map<K, R>
        return [for(k => v in self) k => f(v)];

    public inline static function values<K, V>(self: Map<K, V>): Array<V>
        return [for(_ => v in self) v];

    public inline static function getOption<K, V>(self: Map<K, V>, key: K): Option<V>
        return self.get(key).ofValue();

    public inline static function withDefault<K, V>(self: Map<K, V>, key: K, defaultValue: V): V {
        final v = self.get(key);
        return if(v == null) defaultValue else v;
    }

    public inline static function withDefaultLazy<K, V>(self: Map<K, V>, key: K, thunk: () -> V): V {
        final v = self.get(key);
        return if(v == null) thunk() else v;
    }

    public inline static function withDefaultOrSet<K, V>(self: Map<K, V>, key: K, defaultValue: V): V {
        final v = self.get(key);
        return if(v == null) {
            self.set(key, defaultValue);
            defaultValue;
        } else v;
    }

    public inline static function withDefaultLazyOrSet<K, V>(self: Map<K, V>, key: K, thunk: () -> V): V {
        final v = self.get(key);
        return if(v == null) {
            final setValue = thunk();
            self.set(key, setValue);
            setValue;
        } else v;
    }

    public inline static function update<K, V>(self: Map<K, V>, key: K, f: Null<V> -> V): V {
        final v = self.get(key);
        self.set(key, f(v));
        return v;
    }

    public inline static function isEmpty<K, V>(self: Map<K, V>): Bool
        return !self.iterator().hasNext();

    public inline static function merge<K, V>(self: Map<K, V>, other: Map<K, V>): Map<K, V> {
        final result = self.copy();
        for(k => v in other)
            result.set(k, v);
        return result;
    }

    public inline static function reduce<K, V, R>(self: Map<K, V>, init: R, f: R -> K -> V -> R): R {
        for(k => v in self)
            init = f(init, k, v);
        return init;
    }

    public inline static function toArray<K, V>(self: Map<K, V>): Array<Tuple<K, V>> {
        final result = [];
        for(k => v in self)
            result.push(Tuple.of(k, v));
        return result;
    }

    public inline static function string<K, V>(v: Map<K, V>): String {
        final fields = MapExt.toArray(v).map(t -> '${DynamicExt.string(t.left)} => ${DynamicExt.string(t.right)}');
        return '[${fields.join(", ")}]';
    }

    public inline static function isMap(v: Dynamic): Bool
        return Std.isOfType(v, IMap);
}
