$version: "2.0"

namespace smithy.stateslanguage

@trait
structure mapState {
    type: String = "Map"
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
    maxConcurrency: NonNegativeInteger = 0
    maxConcurrencyPath: StatePath
    toleratedFailurePercentage: PercentageInteger
    toleratedFailurePercentagePath: StatePath
    toleratedFailureCount: NonNegativeInteger = 0
    toleratedFailureCountPath: StatePath
}

structure StateItemReader {
    @required
    resource: StateURI
    parameters: StatePayloadTemplate
    readerConfig: StateItemReaderConfig
}

structure StateItemReaderConfig {
    maxItems: PositiveInteger
    maxItemsPath: StatePath
}

structure StateItemBatcher {
    batchInput: StatePayloadTemplate
    maxItemsPerBatch: PositiveInteger
    maxItemsPerBatchPath: StatePath
    maxInputBytesPerBatch: PositiveInteger
    maxInputBytesPerBatchPath: StatePath
}

structure StateResultWriter {
    @required
    resource: StateURI
    parameters: StatePayloadTemplate
}

structure StateItemProcessor {
    @required
    @length(min: 1)
    states: States

    @required
    startAt: StateName

    processorConfig: StatePayloadTemplate
}
