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
    seconds: PositiveInteger
    secondsPath: StatePath
    timestamp: StateTimestamp
    timestampPath: StatePath
}
