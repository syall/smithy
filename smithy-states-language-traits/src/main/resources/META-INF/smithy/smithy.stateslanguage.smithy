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
/// Transitions link states together, defining the control flow for the state
/// machine. After executing a non-terminal state, the interpreter follows a
/// transition to the next state. For most state types, transitions are
/// unconditional and specified through the state's "Next" field.
/// 
/// All non-terminal states MUST have a "Next" field, except for the Choice
/// State. The value of the "Next" field MUST exactly and case-sensitively
/// match the name of the another state.
/// 
/// States can have multiple incoming transitions from other states.
@mixin
@trait(selector: "structure")
structure stateMixin {
    @required
    type: String
    comment: String
    end: Boolean
    next: StateName
    input: StateUnit
    output: StateUnit
    inputPath: StatePath
    parameters: StateUnit
    resultSelector: StateUnit
    resultPath: StatePath
    outputPath: StatePath
    retry: StateRetry
    catch: StateCatch
}

/// The state name, whose length MUST BE less than or equal to 80 Unicode
/// characters.
@length(min: 1, max: 80)
string StateName

string StatePath

/// Timestamps
/// The Choice and Wait States deal with JSON field values which represent
/// timestamps. These are strings which MUST conform to the RFC3339 profile of
/// ISO 8601, with the further restrictions that an uppercase "T" character
/// MUST be used to separate date and time, and an uppercase "Z" character MUST
//  be present in the absence of a numeric time zone offset, for example
/// "2016-03-14T01:59:00Z".
@timestampFormat("date-time")
timestamp StateTimestamp

/// Data / The interpreter passes data between states to perform calculations or
/// to dynamically control the state machine’s flow. All such data MUST be
/// expressed in JSON.
/// 
/// When a state machine is started, the caller can provide an initial JSON text
/// as input, which is passed to the machine's start state as input. If no input
/// is provided, the default is an empty JSON object, {}. As each state is
/// executed, it receives a JSON text as input and can produce arbitrary output,
/// which MUST be a JSON text. When two states are linked by a transition, the
/// output from the first state is passed as input to the second state. The output
/// from the machine's terminal state is treated as its output.
/// 
/// For example, consider a simple state machine that adds two numbers together:
/// 
/// {
///   "StartAt": "Add",
///   "States": {
///     "Add": {
///       "Type": "Task",
///       "Resource": "arn:aws:lambda:us-east-1:123456789012:function:Add",
///       "End": true
///     }
///   }
/// }
///
/// Suppose the "Add" Lambda function is defined as:
/// 
/// exports.handler = function(event, context) { 
///   context.succeed(event.val1 + event.val2);
/// };
/// Then if this state machine was started with the input
/// { "val1": 3, "val2": 4 }, then the output would be the JSON text consisting
/// of the number 7.
/// 
/// The usual constraints applying to JSON-encoded data apply. In particular,
/// note that:
/// 
/// 1. Numbers in JSON generally conform to JavaScript semantics, typically
///    corresponding to double-precision IEEE-854 values. For this and other
///    interoperability concerns, see RFC 8259.
/// 
/// 2. Standalone "-delimited strings, booleans, and numbers are valid JSON
///    texts.
/// This trait represents the undocumented input / output type between states.
structure StateUnit {}

list StateRetry {
    member: StateRetrier
}

structure StateRetrier {
    @required
    errorEquals: StateErrorList
    @range(min: 1)
    intervalSeconds: Integer = 1
    @range(min: 0)
    maxAttempts: Integer = 3
    @range(min: 1.0)
    backoffRate: Float = 2.0
}

@length(min: 1)
list StateErrorList {
    member: StateError
}

enum StateError {
    /// A wildcard which matches any Error Name.
    STATES_ALL = "States.ALL"

    /// A Task State failed to heartbeat for a time longer than the "HeartbeatSeconds" value.
    STATES_HEARTBEATTIMEOUT	= "States.HeartbeatTimeout"

    /// A Task State either ran longer than the "TimeoutSeconds" value, or failed to heartbeat for a time longer than the "HeartbeatSeconds" value.
    STATES_TIMEOUT = "States.Timeout"

    /// A Task State failed during the execution.
    STATES_TASKFAILED = "States.TaskFailed"

    /// A Task State failed because it had insufficient privileges to execute the specified code.
    STATES_PERMISSIONS= "States.Permissions"

    /// A state’s "ResultPath" field cannot be applied to the input the state received.
    STATES_RESULTPATHMATCHFAILURE= "States.ResultPathMatchFailure"

    /// Within a state’s "Parameters" field, the attempt to replace a field whose name ends in ".$" using a Path failed.
    STATES_PARAMETERPATHFAILURE= "States.ParameterPathFailure"

    /// A branch of a Parallel State failed.
    STATES_BRANCHFAILED= "States.BranchFailed"

    /// A Choice State failed to find a match for the condition field extracted from its input.
    STATES_NOCHOICEMATCHED= "States.NoChoiceMatched"

    /// Within a Payload Template, the attempt to invoke an Intrinsic Function failed.
    STATES_INTRINSICFAILURE= "States.IntrinsicFailure"

    /// A Map state failed because the number of failed items exceeded the configured tolerated failure threshold.
    STATES_EXCEEDTOLERATEDFAILURETHRESHOLD= "States.ExceedToleratedFailureThreshold"

    /// A Map state failed to read all items as specified by the “ItemReader” field.
    STATES_ITEMREADERFAILED= "States.ItemReaderFailed"

    /// A Map state failed to write all results as specified by the “ResultWriter” field.
    STATES_RESULTWRITERFAILED= "States.ResultWriterFailed"
}

list StateCatch {
    member: StateCatcher
}

structure StateCatcher {
    @required
    errorEquals: StateErrorList
    @required
    next: StateName
    resultPath: StatePath
}
