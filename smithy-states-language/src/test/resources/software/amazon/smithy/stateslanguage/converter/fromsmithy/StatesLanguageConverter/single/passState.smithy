$version: "2.0"

namespace test.passState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
        "NextState": NextTestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#passState)
@smithy.stateslanguage#passState(
    comment: "COMMENT"
    inputPath: "$"
    outputPath: "$"
    nextOrEnd: { next: "NextState" }
    resultPath: "$"
    parameters: {
        "x": 3
        "y": 2
    }
    result: {
        "x": "3"
        "y": "2"
    }
)
structure TestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#passState)
@smithy.stateslanguage#passState(
    nextOrEnd: { end: true }
)
structure NextTestState {}
