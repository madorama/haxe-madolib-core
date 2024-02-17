package madolib;

import haxe.Int64;
import haxe.crypto.Sha1;
import haxe.exceptions.ArgumentException;
import haxe.io.Bytes;
import seedyrng.Xorshift64Plus;

class Random {
    public static final gen = new Random();

    final instance: seedyrng.Random;

    public function new(?seed: Int64) {
        instance =
            #if hl
            new seedyrng.Random(new Xorshift64Plus());
            #else
            new seedyrng.Random();
            #end
        if(seed != null)
            instance.seed = seed;
    }

    public var seed(get, set): Int64;

    inline function set_seed(v: Int64): Int64 {
        return instance.seed = v;
    }

    inline function get_seed(): Int64
        return instance.seed;

    public inline function setStringSeed(newSeed: String) {
        setBytesSeed(Bytes.ofString(newSeed));
    }

    public inline function setBytesSeed(newSeed: Bytes) {
        this.seed = Sha1.make(newSeed).getInt64(0);
    }

    public inline function randomInt(min: Int, max: Int): Int
        return instance.randomInt(min, max);

    public inline function randomBool(): Bool
        return randomInt(0, 1) == 0;

    public inline function random(): Float
        return instance.random();

    public inline function uniform(lower: Float, upper: Float): Float
        return instance.uniform(lower, upper);

    public inline function choice<T>(array: Array<T>): T
        return if(array.length == 0)
            throw new ArgumentException("It is cannot choice from an empty array");
        else
            array[randomInt(0, array.length - 1)];

    public inline function shuffle<T>(array: Array<T>): Array<T> {
        final ret = array.copy();

        for(i in 0...ret.length) {
            final j = randomInt(i, ret.length - 1);
            final a = ret[i];
            ret[i] = ret[j];
            ret[j] = a;
        }
        return ret;
    }

    public inline static function createBoolSampler(trueWeight: Float, falseWeight: Float): WalkersAlias<Bool>
        return new WalkersAlias([
            { item: true, weight: trueWeight },
            { item: false, weight: falseWeight },
        ]);
}
