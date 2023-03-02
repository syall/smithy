$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure parallelState {
    comment: String
    inputPath: StatePathOrNull
    outputPath: StatePathOrNull
    @required
    nextOrEnd: StateNextOrEnd
    resultPath: StatePathOrNull
    resultSelector: StatePayloadTemplate
    parameters: StatePayloadTemplate
    retry: StateRetry
    catch: StateCatch
    // State-specific
    @required
    branches: StateBranchList
}

list StateBranchList{
    member: StateMachineIdRef
}
