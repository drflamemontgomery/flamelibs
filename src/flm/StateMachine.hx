package flm;

class StateMachine<T:Int> {

    private final noState : T;
    public var state(default,null) : T;
    private final enters:Map<T,T->Void> = [];
    private final exits:Map<T,T->Void> = [];
    private final updates:Map<T,Void->T> = [];

    private var onEnter:T->T->Void = (a, b)->{};
    private var onExit:T->T->Void = (a, b)->{};

    public function new(defaultState:T, noState:T) {
        this.state = defaultState;
        this.noState = noState;
    }

    public function exit(cb:T->T->Void) {
        onExit = cb;
    }

    public function enter(cb:T->T->Void) {
        onEnter = cb;
    }

    public final function addState(s:T, update:Void->T, ?enter:T->Void, ?exit:T->Void) {
        if(enter != null) {
            enters.set(s, enter);
        }
        if(exit != null) {
            exits.set(s, exit);
        }
        updates.set(s, update);
    }

    function enterState(from:T, to:T) {
        if(enters.exists(to)) {
            enters[to](from);
        }
        onEnter(from, to);
    }

    function exitState(to:T, from:T) {
        if(exits.exists(from)) {
            exits[from](to);
        }
        onExit(to, from);
    }

    inline function updateState():T {
        if(updates.exists(state)) {
            return updates[state]();
        }
        return noState;
    }

    public function changeState(to:T, from:T) {
        exitState(to, from);
        enterState(to, from);
        state = to;
    }

    public function update() {
        final s:T = updateState();
        if(s != noState) {
            exitState(state, s);
            enterState(s, state);
            state = s;
        }
    }

    public function toString():String {
        return '[#StateMachine enters:$enters exits:$exits updates:$updates]';
    }
}
