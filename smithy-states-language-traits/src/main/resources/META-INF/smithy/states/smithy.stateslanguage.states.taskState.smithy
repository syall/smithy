$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure taskState {
    comment: String
    inputPath: StatePathOrNull
    outputPath: StatePathOrNull
    @required
    nextOrEnd: StateNextOrEnd
    resultPath: StatePathOrNull
    parameters: StatePayloadTemplate
    resultSelector: StatePayloadTemplate
    retry: StateRetry
    catch: StateCatch
    // State-specific
    @required
    resource: StateURI
    timeoutSeconds: TimeoutSecondsOrStatePath
    heartbeatSeconds: HeartbeatSecondsOrStatePath
    credentials: StatePayloadTemplate
}

union TimeoutSecondsOrStatePath {
    value: PositiveInteger
    path: StatePath
}

union HeartbeatSecondsOrStatePath {
    value: PositiveInteger
    path: StatePath
}
