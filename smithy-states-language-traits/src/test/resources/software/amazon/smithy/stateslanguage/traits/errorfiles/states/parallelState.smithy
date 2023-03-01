$version: "2.0"

namespace test.parallelState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
        "NextState": NextTestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#parallelState)
@smithy.stateslanguage#parallelState(
    comment: "COMMENT"
    inputPath: "$"
    outputPath: "$"
    nextOrEnd: { next: "NextState" }
    resultPath: "$"
    parameters: {
        x: 3
        y: 2
    }
    resultSelector: {
        selected: "selected"
    }
    retry: [
        {
            errorEquals: [
                "States.ALL"
            ]
            intervalSeconds: 2
            maxAttempts: 1
            backoffRate: 1.2
        }
    ]
    catch: [
        {
            errorEquals: [
                "States.ALL"
            ]
            next: "NextTestState"
            resultPath: "$"
        }
    ]
    branches: [
        {
            startAt: "NextState"
            states: {
                "NextState": NextTestState
            }
        }
    ]
)
structure TestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#parallelState)
@smithy.stateslanguage#parallelState(
    nextOrEnd: { end: true }
)
structure NextTestState {}
