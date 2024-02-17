package madolib.event;

@:structInit
class SignalCallback0 {
    final callback: () -> Void;

    public var priority = 0;
    public var repeat = -1;

    var remove = false;
    var callCount = 0;

    public function new(callback: () -> Void) {
        this.callback = callback;
    }

    inline function invoke() {
        Callback.guardStackoverflow(() -> callback());
        callCount++;
        if(repeat >= 0 && callCount >= repeat) remove = true;
    }

    public inline function cancel() {
        remove = true;
    }
}

@:access(madolib.event.SignalCallback0)
private class Signal0Impl implements Disposable {
    var requiresSort = false;
    var callbacks: Array<SignalCallback0> = [];

    public var disposed(default, null) = false;

    public function new() {}

    public function dispose() {
        if(disposed) return;
        disposed = true;
        callbacks = [];
    }

    inline function sortPriority() {
        if(!requiresSort) return;
        callbacks.sort((s1, s2) -> {
            if(s1.priority > s2.priority)
                -1;
            else if(s1.priority < s2.priority)
                1;
            else
                0;
        });
        requiresSort = false;
    }

    public inline function add(callback: () -> Void, priority = 0, once = false): SignalCallback0 {
        final scb = new SignalCallback0(callback);
        scb.priority = priority;
        if(once) scb.repeat = 1;
        if(priority != 0) requiresSort = true;
        callbacks.push(scb);
        return scb;
    }

    public inline function invoke() {
        sortPriority();

        var i = 0;
        while(i < callbacks.length) {
            var cb = callbacks[i];
            if(!cb.remove) cb.invoke();
            if(cb.remove) {
                callbacks.splice(i, 1);
            } else {
                i++;
            }
        }
    }

    extern overload public inline function remove(signalCallback: SignalCallback0) {
        var i = 0;
        while(i < callbacks.length) {
            if(callbacks[i] == signalCallback) {
                callbacks.splice(i, 1);
            } else {
                i++;
            }
        }
    }

    extern overload public inline function remove(callback: () -> Void) {
        var i = 0;
        while(i < callbacks.length) {
            if(callbacks[i].callback == callback) {
                callbacks.splice(i, 1);
            } else {
                i++;
            }
        }
    }
}

@:forward(add, remove, dispose, disposed)
abstract Signal0(Signal0Impl) from Signal0Impl {
    public inline function new()
        this = new Signal0Impl();

    @:op(A()) public inline function invoke()
        this.invoke();
}
