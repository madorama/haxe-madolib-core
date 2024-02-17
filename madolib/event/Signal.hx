package madolib.event;

@:structInit
class SignalCallback<T> {
    final callback: Callback<T>;

    public var priority = 0;
    public var repeat = -1;

    var remove = false;
    var callCount = 0;

    public function new(callback: T -> Void) {
        this.callback = callback;
    }

    inline function invoke(value: T) {
        callback.invoke(value);
        callCount++;
        if(repeat >= 0 && callCount >= repeat) remove = true;
    }

    public inline function cancel() {
        remove = true;
    }
}

@:access(madolib.event.SignalCallback)
private class SignalImpl<T> implements Disposable {
    var requiresSort = false;
    var callbacks: Array<SignalCallback<T>> = [];

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

    public inline function add(callback: Callback<T>, priority = 0, once = false): SignalCallback<T> {
        final scb = new SignalCallback<T>(callback);
        scb.priority = priority;
        if(once) scb.repeat = 1;
        if(priority != 0) requiresSort = true;
        callbacks.push(scb);
        return scb;
    }

    public inline function invoke(value: T) {
        sortPriority();

        var i = 0;
        while(i < callbacks.length) {
            var cb = callbacks[i];
            if(!cb.remove) cb.invoke(value);

            if(cb.remove) {
                callbacks.splice(i, 1);
            } else {
                i++;
            }
        }
    }

    extern overload public inline function remove(signalCallback: SignalCallback<T>) {
        var i = 0;
        while(i < callbacks.length) {
            if(callbacks[i] == signalCallback) {
                callbacks.splice(i, 1);
            } else {
                i++;
            }
        }
    }

    extern overload public inline function remove(callback: Callback<T>) {
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
abstract Signal<T>(SignalImpl<T>) from SignalImpl<T> {
    public inline function new()
        this = new SignalImpl<T>();

    @:op(A()) public inline function invoke(value: T)
        this.invoke(value);
}
