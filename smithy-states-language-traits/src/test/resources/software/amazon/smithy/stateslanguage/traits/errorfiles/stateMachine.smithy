$version: "2.0"

namespace smithy.stateMachine.example

@smithy.stateslanguage#state
@smithy.stateslanguage#passState(
    comment: "No operation"
    nextOrEnd: { end: true }
)
structure NoopState {}

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
