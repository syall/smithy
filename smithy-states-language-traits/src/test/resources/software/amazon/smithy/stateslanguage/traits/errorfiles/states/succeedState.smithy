$version: "2.0"

namespace test.succeedState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#succeedState)
@smithy.stateslanguage#succeedState(
    comment: "COMMENT"
    inputPath: { path: "$" }
    outputPath: { null: true }
)
structure TestState {}
