$version: "2.0"

namespace smithy.stateslanguage

@trait
structure taskState {
    type: String = "Task"
    comment: String
    inputPath: StatePath
    outputPath: StatePath
    @required
    nextOrEnd: StateNextOrEnd
    resultPath: StatePath
    parameters: StatePayloadTemplate
    resultSelector: StatePayloadTemplate
    retry: StateRetry
    catch: StateCatch
    // State-specific
    @required
    resource: StateURI
    timeoutSeconds: PositiveInteger = 60
    heartbeatSeconds: PositiveInteger
    timeoutSecondsPath: StatePath
    heartbeatSecondsPath: StatePath
    credentials: StatePayloadTemplate
}
