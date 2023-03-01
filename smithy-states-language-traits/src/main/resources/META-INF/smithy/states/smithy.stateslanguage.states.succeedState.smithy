$version: "2.0"

namespace smithy.stateslanguage

@trait
structure succeedState {
    type: String = "Succeed"
    comment: String
    inputPath: StatePath
    outputPath: StatePath
}
