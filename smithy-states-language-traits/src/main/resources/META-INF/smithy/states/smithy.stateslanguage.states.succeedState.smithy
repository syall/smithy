$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure succeedState {
    type: String = "Succeed"
    comment: String
    inputPath: StatePath
    outputPath: StatePath
}
