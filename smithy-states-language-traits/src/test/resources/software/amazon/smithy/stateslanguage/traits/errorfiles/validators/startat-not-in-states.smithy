$version: "2.0"

namespace startat.not.in.states

@smithy.stateslanguage#stateMachine(
    startAt: "Not in states"
    states: {
        "In State": InState
    }
)
structure StartAtNotInStatesStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#succeedState)
@smithy.stateslanguage#succeedState
structure InState {}
