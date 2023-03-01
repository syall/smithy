$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure succeedState {
    comment: String
    inputPath: StatePath
    outputPath: StatePath
}
