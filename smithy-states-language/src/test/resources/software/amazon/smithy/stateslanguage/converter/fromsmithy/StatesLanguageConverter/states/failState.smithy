$version: "2.0"

namespace test.failState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#failState)
@smithy.stateslanguage#failState(
    comment: "COMMENT"
    error: "ERROR"
    cause: "CAUSE"
)
structure TestState {}
