$version: "2.0"

namespace test.waitState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
        "NextState": NextTestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#waitState)
@smithy.stateslanguage#waitState(
    comment: "COMMENT"
    inputPath: "$"
    outputPath: "$"
    nextOrEnd: { next: "NextState" }
    seconds: { value: 1 }
    timestamp: { value: "2023-03-01T09:16:04Z" }
)
structure TestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#waitState)
@smithy.stateslanguage#waitState(
    nextOrEnd: { end: true }
    seconds: { path: "$" }
    timestamp: { path: "$" }
)
structure NextTestState {}
