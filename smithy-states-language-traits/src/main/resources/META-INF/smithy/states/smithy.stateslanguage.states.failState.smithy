$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure failState {
    comment: String
    // State-specific
    @required
    error: String
    @required
    cause: String
}
