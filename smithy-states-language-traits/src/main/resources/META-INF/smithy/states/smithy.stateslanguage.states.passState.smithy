$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure passState {
    comment: String
    @required
    nextOrEnd: StateNextOrEnd
    inputPath: StatePathOrNull
    outputPath: StatePathOrNull
    resultPath: StatePathOrNull
    parameters: StatePayloadTemplate
    // State-specific
    result: StatePayloadTemplate
}
