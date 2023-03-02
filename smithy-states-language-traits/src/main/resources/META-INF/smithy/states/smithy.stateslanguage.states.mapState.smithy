$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure mapState {
    comment: String
    inputPath: StatePath
    outputPath: StatePath
    @required
    nextOrEnd: StateNextOrEnd
    resultPath: StatePath
    resultSelector: StatePayloadTemplate
    parameters: StatePayloadTemplate
    retry: StateRetry
    catch: StateCatch
    // State-specific
    @required
    itemProcessor: StateItemProcessor
    itemsPath: StatePath
    itemReader: StateItemReader
    itemSelector: StatePayloadTemplate
    itemBatcher: StateItemBatcher
    resultWriter: StateResultWriter
    maxConcurrency: MaxConcurrencyOrStatePath
    toleratedFailurePercentage: ToleratedFailurePercentageOrStatePath
    toleratedFailureCount: ToleratedFailureCountOrStatePath
}

union MaxConcurrencyOrStatePath {
    value: NonNegativeInteger
    path: StatePath
}

union ToleratedFailurePercentageOrStatePath {
    value: PercentageInteger
    path: StatePath
}

union ToleratedFailureCountOrStatePath {
    value: NonNegativeInteger
    path: StatePath
}

structure StateItemReader {
    @required
    resource: StateURI
    parameters: StatePayloadTemplate
    readerConfig: StateItemReaderConfig
}

structure StateItemReaderConfig {
    maxItems: MaxItemsOrStatePath
}

union MaxItemsOrStatePath {
    value: PositiveInteger
    path: StatePath
}

structure StateItemBatcher {
    batchInput: StatePayloadTemplate
    maxItemsPerBatch: MaxItemsPerBatchOrStatePath
    maxInputBytesPerBatch: MaxInputBytesPerBatchOrStatePath
}

union MaxItemsPerBatchOrStatePath {
    value: PositiveInteger
    path: StatePath
}

union MaxInputBytesPerBatchOrStatePath {
    value: PositiveInteger
    path: StatePath
}

structure StateResultWriter {
    @required
    resource: StateURI
    parameters: StatePayloadTemplate
}

structure StateItemProcessor {
    @required
    stateMachine: StateMachineIdRef
    processorConfig: StatePayloadTemplate
}
