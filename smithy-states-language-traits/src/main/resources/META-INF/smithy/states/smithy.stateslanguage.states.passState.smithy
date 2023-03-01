$version: "2.0"

namespace smithy.stateslanguage

@trait
structure passState {
    type: String = "Pass"
    comment: String
    @required
    nextOrEnd: StateNextOrEnd
    inputPath: StatePath
    outputPath: StatePath
    resultPath: StatePath
    parameters: StatePayloadTemplate
    // State-specific
    result: StatePayloadTemplate
}
