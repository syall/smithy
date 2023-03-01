$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure parallelState {
    comment: String
    inputPath: StatePath
    outputPath: StatePath
    @required
    nextOrEnd: StateNextOrEnd
    resultPath: StatePath
    resultSelector: StatePayloadTemplate
    parameters: StatePayloadTemplate
    retry: StateRetry
    catch: StateCatch
    // State-specific
    branches: StateBranchList
}

list StateBranchList{
    member: StateBranch
}

structure StateBranch {
    @required
    startAt: StateName
    @required
    states: States
}
