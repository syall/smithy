$version: "2.0"

namespace smithy.stateMachine.example

@smithy.stateslanguage#state
structure NoopState {
    @required
    type: String = "Pass"
    comment: String = "No operation"
    end: Boolean = true
}

@smithy.stateslanguage#stateMachine(
    states: {
        "BeginningAndEnd": NoopState
    }
    startAt: "BeginningAndEnd"
    comment: "This is an example state machine"
    version: "1.0"
    timeoutSeconds: 100
)
structure StateMachineExample {}
