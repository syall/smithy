$version: "2.0"

namespace smithy.stateslanguage

@externalDocumentation(
    "Amazon States Language Specification": "https://states-language.net/spec.html"
)
@trait(selector: "structure")
structure stateMachine {
    @required
    @length(min: 1)
    states: States

    @required
    startAt: StateName

    comment: String

    version: String = "1.0"

    timeoutSeconds: NonNegativeInteger
}

map States {
    key: StateName
    value: StateIdRef
}

@idRef(failWhenMissing: true, selector: "structure [trait|smithy.stateslanguage#state]")
string StateIdRef

@trait(selector: "structure")
structure state {
    @required
    definition: StateDefinitionIdRef
}

@idRef(failWhenMissing: true, selector: "[trait|trait]")
string StateDefinitionIdRef

@trait(selector: "structure")
structure stateDefinition {}

@idRef(failWhenMissing: true, selector: "structure [trait|smithy.stateslanguage#stateMachine]")
string StateMachineIdRef

@length(min: 1, max: 80)
string StateName

string StatePath

union StatePathOrNull {
    path: StatePath
    null: Boolean
}

union StateNextOrEnd {
    next: StateName
    end: Boolean
}

string StateURI

document StatePayloadTemplate

@range(min: 1)
integer PositiveInteger

@range(min: 0)
integer NonNegativeInteger

@range(min: 1.0)
float PositiveFloatGreaterThan1

@timestampFormat("date-time")
timestamp StateTimestamp

@range(min: 0, max: 100)
integer PercentageInteger
