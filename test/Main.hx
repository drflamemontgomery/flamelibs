package;

enum abstract TestState(Int) from Int to Int {
    var NoState = 0;
    var TestState1;
    var TestState2;
}

class Main {

    #if !macro
    public static function main() {
        #if verbose
        dn.CiAssert.VERBOSE = true;
        #end
        new Main();
    }

    public function new() {
       testStateMachine();
    }

    function testState1() {
        return TestState2;
    }

    function testState2() {
        return TestState1;
    }

    function emptyStateFunc(s:TestState) {
    }

    function testStateMachine() {
        var sm = new flm.StateMachine<TestState>(TestState1, NoState);
        sm.addState(TestState1, testState1);
        sm.addState(TestState2, testState2);
        dn.CiAssert.equals(sm.state, TestState1);
        sm.update();
        dn.CiAssert.equals(sm.state, TestState2);
    }
    #end
}
