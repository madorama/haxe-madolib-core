package madolib;

import madolib.event.Signal0;
import madolib.event.Signal;

using tweenxcore.Tools;
using madolib.extensions.ArrayExt;

@:structInit
@:allow(madolib.Tween)
final class TweenData {
    var done = false;
    var name = "";
    var factor = 0.;
    var easeFunction = tweenxcore.Tools.Easing.linear;

    public final onStart = new Signal0();
    public final onUpdate = new Signal<Float>();
    public final onComplete = new Signal0();

    public var from: Float;
    public var to: Float;
    public var speed: Float;
    public var delay = 0.;

    public function new(from: Float, to: Float, speed: Float) {
        this.from = from;
        this.to = to;
        this.speed = speed;
    }

    public inline function ease(func: Float -> Float): TweenData {
        easeFunction = func;
        return this;
    }

    public inline function setName(name: String): TweenData {
        this.name = name;
        return this;
    }

    public inline function setDelay(delay: Float): TweenData {
        this.delay = delay;
        return this;
    }

    inline function complete() {
        if(onComplete.disposed) return;
        onComplete();

        onStart.dispose();
        onUpdate.dispose();
        onComplete.dispose();
    }

    inline function run(dt: Float): Bool {
        if(delay > 0) {
            delay -= dt;
            return false;
        }
        if(!onStart.disposed) {
            onStart();
            onStart.dispose();
        }

        factor += speed * dt;
        if(factor >= 1) {
            factor = 1;
            done = true;
        }

        final rate = easeFunction(factor).lerp(from, to);
        onUpdate(rate);

        if(done) {
            complete();
            return true;
        }
        return false;
    }
}

class Tween {
    final tweens: Array<TweenData> = [];

    public static final inst = new Tween();

    public function new() {}

    public function update(dt: Float) {
        var i = 0;
        while(i < tweens.length) {
            final tween = tweens[i];
            if(tween.run(dt)) {
                tweens.splice(i, 1);
                continue;
            }
            i += 1;
        }
    }

    public function timer(frames: Float, delay = 0., ?onComplete: Void -> Void): TweenData {
        final tween = new TweenData(0, 1, 1 / frames);
        if(onComplete != null) {
            tween.onComplete.add(onComplete);
        }
        tween.setDelay(delay);
        tweens.push(tween);
        return tween;
    }

    public function tween(start: Float, end: Float, frames: Float, delay = 0., ?onUpdate: Float -> Void): TweenData {
        final tween = new TweenData(start, end, 1 / frames);

        if(onUpdate != null) {
            tween.onUpdate.add(onUpdate);
        }

        tween.setDelay(delay);
        tweens.push(tween);
        return tween;
    }

    public inline function kill(tw: TweenData) {
        tweens.remove(tw);
    }

    public function stop(name: String, withComplete: Bool = false) {
        tweens.removeBy(t -> {
            final r = t.name == name;
            if(r && withComplete) t.complete();
            return r;
        });
    }
}
