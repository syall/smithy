$version: "2.0"

namespace test.taskState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
        "NextState": NextTestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    comment: "COMMENT"
    inputPath: { path: "$" }
    outputPath: { path: "$" }
    nextOrEnd: { next: "NextState" }
    resultPath: { path: "$" }
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
            resultPath: { path: "$" }
        }
    ]
    resource: "www.amazon.com"
    timeoutSeconds: { value: 2 }
    heartbeatSeconds: { value: 1 }
    credentials: {
        token: "TOKEN"
    }
)
structure TestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    inputPath: { null: true }
    outputPath: { null: true }
    resultPath: { null: true }
    nextOrEnd: { end: true }
    resource: "www.aws.com"
    timeoutSeconds: { path: "$" }
    heartbeatSeconds: { path: "$" }
)
structure NextTestState {}
