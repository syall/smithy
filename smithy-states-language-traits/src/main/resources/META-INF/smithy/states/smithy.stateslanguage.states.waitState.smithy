$version: "2.0"

namespace smithy.stateslanguage

@trait
structure waitState {
    type: String = "Wait"
    comment: String
    inputPath: StatePath
    outputPath: StatePath
    @required
    nextOrEnd: StateNextOrEnd
    // State-specific
    seconds: SecondsOrStatePath
    timestamp: TimestampOrStatePath
}

union SecondsOrStatePath {
    value: PositiveInteger
    path: StatePath
}

union TimestampOrStatePath {
    value: StateTimestamp
    path: StatePath
}
