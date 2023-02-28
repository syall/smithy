$version: "2.0"

namespace smithy.stateslanguage

/// The operation of a state machine is specified by states, which are
/// represented by structures with the smithy.stateslanguage#state trait,
/// fields in the top-level smithy.stateslanguage#stateMachine$states.
/// 
/// When this state machine is launched, the interpreter begins execution
/// by identifying the state at smithy.stateslanguage#stateMachine$startAt.
/// It executes that state, and then checks to see if the state is marked
/// as an TODO(stateslanguage) End State. If it is, the machine
/// terminates and returns a result. If the state is not an
/// TODO(stateslanguage) End State, the interpreter looks for a
/// TODO(stateslanguage) "Next" field to determine what state to run next;
/// it repeats this process until it reaches a TODO(stateslanguage)
/// Terminal State (Succeed, Fail, or an End State) or a TODO(stateslanguage)
/// runtime error occurs.
@externalDocumentation(
    "Amazon States Language Specification": "https://states-language.net/spec.html"
    "State Machine Top-level fields": "https://states-language.net/spec.html#toplevelfields"
)
@trait(selector: "structure")
structure stateMachine {
    /// A State Machine MUST have an object field named TODO(stateslanguage)
    /// "States", whose fields represent the states.
    @required
    @length(min: 1)
    states: States

    /// A State Machine MUST have a string field named TODO(stateslanguage)
    /// "StartAt", whose value MUST exactly match one of names of the
    /// TODO(stateslanguage) "States" fields. The interpreter starts running
    /// the the machine at the named state.
    @required
    startAt: StateName

    /// A State Machine MAY have a string field named TODO(stateslanguage)
    /// "Comment", provided for human-readable description of the machine.
    comment: String

    /// A State Machine MAY have a string field named TODO(stateslanguage)
    /// "Version", which gives the version of the States language used in
    /// the machine. This document describes version 1.0, and if omitted,
    /// the default value of version is the string "1.0".
    version: String = "1.0"

    /// A State Machine MAY have an integer field named TODO(stateslanguage)
    /// "TimeoutSeconds". If provided, it provides the maximum number of
    /// seconds the machine is allowed to run. If the machine runs longer than
    /// the specified time, then the interpreter fails the machine with a
    /// TODO(stateslanguage) States.Timeout Error Name.
    timeoutSeconds: Integer
}

/// States are represented as fields of the top-level TODO(stateslanguage)
/// "States" object.
@externalDocumentation(
    "States": "https://states-language.net/spec.html#states-fields"
)
map States {
    /// The state name is the field name; state names MUST be unique within the
    /// scope of the whole state machine.
    key: StateName
    value: StateIdRef
}

/// Reference to a State
@idRef(failWhenMissing: true, selector: "structure [trait|smithy.stateslanguage#state]")
string StateIdRef

/// States describe tasks (units of work), or specify flow control (e.g.
/// Choice).
/// Here is an example state that executes a Lambda function:
/// ```json
/// "HelloWorld": {
///   "Type": "Task",
///   "Resource": "arn:aws:lambda:us-east-1:123456789012:function:HelloWorld",
///   "Next": "NextState",
///   "Comment": "Executes the HelloWorld Lambda function"
/// }
/// ```
@trait(selector: "structure")
structure state {}

/// Note that:
/// 1. All states MUST have a TODO(stateslanguage) "Type" field. This document
///    refers to the values of this field as a state’s type.
/// 2. Any state MAY have a TODO(stateslanguage) "Comment" field, to hold a
///    human-readable comment or description.
/// 3. Most state types require additional TODO(stateslanguage) fields as
///    specified in this document.
/// 4. Any state except for TODO(stateslanguage) Choice, Succeed, and Fail MAY
///    have a field named TODO(stateslanguage) "End" whose value MUST be a
///    boolean. The term TODO(stateslanguage) "Terminal State" means a state
///    with { "End": true }, or a state with { "Type": "Succeed" }, or a state
///    with { "Type": "Fail" }.
@mixin
@trait(selector: "structure")
structure stateMixin {
    @required
    type: String
    comment: String
    end: Boolean
    next: String
}

/// The state name, whose length MUST BE less than or equal to 80 Unicode
/// characters.
@length(min: 1, max: 80)
string StateName

@timestampFormat("date-time")
timestamp StateTimestamp
