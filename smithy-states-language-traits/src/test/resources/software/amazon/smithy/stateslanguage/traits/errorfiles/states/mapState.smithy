$version: "2.0"

namespace test.mapState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
        "NextState": NextTestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#mapState)
@smithy.stateslanguage#mapState(
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
    itemProcessor: {
        stateMachine: TestMappedStateMachine
        processorConfig: {
            prop: "prop"
        }
    }
    itemsPath: "$"
    itemReader: {
        resource: "www.amazon.com"
        parameters: {
            test: "test"
        }
        readerConfig: {
            maxItems: { value: 10 }
        }
    }
    itemSelector: {
        x: 3
        y: 2
    }
    itemBatcher: {
        batchInput: {
            x: 3
            y: 2
        }
        maxItemsPerBatch: { value: 10 }
        maxInputBytesPerBatch: { value: 1000 }
    }
    resultWriter: {
        resource: "www.aws.com"
        parameters: {
            test: "test"
        }
    }
    maxConcurrency: { value: 1 }
    toleratedFailurePercentage: { value: 0 }
    toleratedFailureCount: { value: 1 }
)
structure TestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#mapState)
@smithy.stateslanguage#mapState(
    inputPath: { null: true }
    outputPath: { null: true }
    nextOrEnd: { end: true }
    resultPath: { null: true }
    itemProcessor: {
        stateMachine: TestMappedStateMachine
        processorConfig: {
            prop: "prop"
        }
    }
    itemReader: {
        resource: "www.amazon.com"
        readerConfig: {
            maxItems: { path: "$" }
        }
    }
    itemBatcher: {
        maxItemsPerBatch: { path: "$" }
        maxInputBytesPerBatch: { path: "$" }
    }
    maxConcurrency: { path: "$" }
    toleratedFailurePercentage: { path: "$" }
    toleratedFailureCount: { path: "$" }
)
structure NextTestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#succeedState)
@smithy.stateslanguage#succeedState()
structure TerminalTestState {}

@smithy.stateslanguage#stateMachine(
    states: {
        "TerminalState": TerminalTestState
    }
    startAt: "TerminalState"
)
structure TestMappedStateMachine {}
