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
    next: String
    input: StateUnit
    output: StateUnit
}

/// The state name, whose length MUST BE less than or equal to 80 Unicode
/// characters.
@length(min: 1, max: 80)
string StateName

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


/// The Context Object The interpreter can provide information to an executing
/// state machine about the execution and other implementation details. This is
/// delivered in the form of a JSON object called the "Context Object". This
/// version of the States Language specification does not specify any contents of
/// the Context Object.
structure StateContext {}

/// Paths
/// A Path is a string, beginning with "$", used to identify components
/// with a JSON text. The syntax is that of JsonPath.
///
/// When a Path begins with "$$", two dollar signs, this signals that it is
/// intended to identify content within the Context Object. The first dollar sign
/// is stripped, and the remaining text, which begins with a dollar sign, is
/// interpreted as the JSONPath applying to the Context Object.
/// Reference Paths
/// A Reference Path is a Path with syntax limited in such a way that it can only identify a single node in a JSON structure: The operators "@", ",", ":", and "?" are not supported - all Reference Paths MUST be unambiguous references to a single value, array, or object (subtree).
/// 
/// For example, if state input data contained the values:
/// 
/// {
///     "foo": 123,
///     "bar": ["a", "b", "c"],
///     "car": {
///         "cdr": true
///     }
/// }
/// Then the following Reference Paths would return:
/// 
/// $.foo => 123
/// $.bar => ["a", "b", "c"]
/// $.car.cdr => true
/// Paths and Reference Paths are used by certain states, as specified later in this document, to control the flow of a state machine or to configure a state's settings or options.
/// 
/// Here are some examples of acceptable Reference Path syntax:
/// 
/// $.store.book
/// $.store\.book
/// $.\stor\e.boo\k
/// $.store.book.title
/// $.foo.\.bar
/// $.foo\@bar.baz\[\[.\?pretty
/// $.&Ж中.\uD800\uDF46
/// $.ledgers.branch[0].pending.count
/// $.ledgers.branch[0]
/// $.ledgers[0][22][315].foo
/// $['store']['book']
/// $['store'][0]['book']
@pattern("^$.*$")
string StatePath

/// Payload Template
/// A state machine interpreter dispatches data as input to tasks to do useful work, and receives output back from them. It is frequently desired to reshape input data to meet the format expectations of tasks, and similarly to reshape the output coming back. A JSON object structure called a Payload Template is provided for this purpose.
/// 
/// In the Task, Map, Parallel, and Pass States, the Payload Template is the value of a field named "Parameters". In the Task, Map, and Parallel States, there is another Payload Template which is the value of a field named "ResultSelector".
/// 
/// A Payload Template MUST be a JSON object; it has no required fields. The interpreter processes the Payload Template as described in this section; the result of that processing is called the payload.
/// 
/// To illustrate by example, the Task State has a field named "Parameters" whose value is a Payload Template. Consider the following Task State:
/// 
/// "X": {
///   "Type": "Task",
///   "Resource": "arn:aws:states:us-east-1:123456789012:task:X",
///   "Next": "Y",
///   "Parameters": {
///     "first": 88,
///     "second": 99
///   }
/// }
/// In this case, the payload is the object with "first" and "second" fields whose values are respectively 88 and 99. No processing needs to be performed and the payload is identical to the Payload Template.
/// 
/// Values from the Payload Template’s input and the Context Object can be inserted into the payload with a combination of a field-naming convention, Paths and Intrinsic Functions.
/// 
/// If any field within the Payload Template (however deeply nested) has a name ending with the characters ".$", its value is transformed according to rules below and the field is renamed to strip the ".$" suffix.
/// 
/// If the field value begins with only one "$", the value MUST be a Path. In this case, the Path is applied to the Payload Template’s input and is the new field value.
/// 
/// If the field value begins with "$$", the first dollar sign is stripped and the remainder MUST be a Path. In this case, the Path is applied to the Context Object and is the new field value.
/// 
/// If the field value does not begin with "$", it MUST be an Intrinsic Function (see below). The interpreter invokes the Intrinsic Function and the result is the new field value.
/// 
/// If the path is legal but cannot be applied successfully, the interpreter fails the machine execution with an Error Name of "States.ParameterPathFailure". If the Intrinsic Function fails during evaluation, the interpreter fails the machine execution with an Error Name of "States.IntrinsicFailure".
/// 
/// A JSON object MUST NOT have duplicate field names after fields ending with the characters ".$" are renamed to strip the ".$" suffix.
/// 
/// "X": {
///   "Type": "Task",
///   "Resource": "arn:aws:states:us-east-1:123456789012:task:X",
///   "Next": "Y",
///   "Parameters": {
///     "flagged": true,
///     "parts": {
///       "first.$": "$.vals[0]",
///       "last3.$": "$.vals[-3:]"
///     },
///     "weekday.$": "$$.DayOfWeek",
///     "formattedOutput.$": "States.Format('Today is {}', $$.DayOfWeek)"
///   }
/// }
/// Suppose that the input to the P is as follows:
/// 
/// {
///   "flagged": 7,
///   "vals": [0, 10, 20, 30, 40, 50]
/// }
/// Further, suppose that the Context Object is as follows:
/// 
/// {
///   "DayOfWeek": "TUESDAY"
/// }
/// In this case, the effective input to the code identified in the "Resource" field would be as follows:
/// 
/// {
///   "flagged": true,
///   "parts": {
///     "first": 0,
///     "last3": [30, 40, 50]
///   },
///   "weekday": "TUESDAY",
///   "formattedOutput": "Today is TUESDAY"
/// }
structure StatePayloadTemplate {}

/// Intrinsic Functions
/// The States Language provides a small number of "Intrinsic Functions", constructs which look like functions in programming languages and can be used to help Payload Templates process the data going to and from Task Resources. See Appendix B for a full list of Intrinsic Functions
/// 
/// Here is an example of an an Intrinsic Function named "States.Format" being used to prepare data:
/// 
/// "X": {
///   "Type": "Task",
///   "Resource": "arn:aws:states:us-east-1:123456789012:task:X",
///   "Next": "Y",
///   "Parameters": {
///     "greeting.$": "States.Format('Welcome to {} {}\\'s playlist.', $.firstName, $.lastName)"
///   }
/// }
/// An Intrinsic Function MUST be a string.
/// 
/// The Intrinsic Function MUST begin with an Intrinsic Function name. An Intrinsic Function name MUST contain only the characters A through Z, a through z, 0 through 9, ".", and "_".
/// 
/// All Intrinsic Functions defined by this specification have names that begin with "States.". Other implementations may define their own Intrinsic Functions whose names MUST NOT begin with "States.".
/// 
/// The Intrinsic Function name MUST be followed immediately by a list of zero or more arguments, enclosed by "(" and ")", and separated by commas.
/// 
/// Intrinsic Function arguments may be strings enclosed by apostrophe (') characters, numbers, null, Paths, or nested Intrinsic Functions.
/// 
/// The value of a string, number or null argument is the argument itself. The value of an argument which is a Path is the result of applying it to the input of the Payload Template. The value of an argument which is an Intrinsic Function is the result of the function invocation."
/// 
/// Note that in the example above, the first argument of States.Format could have been a Path that yielded the formatting template string.
/// 
/// The following characters are reserved for all Intrinsic Functions and MUST be escaped: ' { } \
/// 
/// If any of the reserved characters needs to appear as part of the value without serving as a reserved character, it MUST be escaped with a backslash.
/// 
/// If the character "\" needs to appear as part of the value without serving as an escape character, it MUST be escaped with a backslash.
/// 
/// The literal string \' represents '.
/// The literal string \{ represents {.
/// The literal string \} represents }.
/// The literal string \\ represents \.
/// 
/// In JSON, all backslashes contained in a string literal value must be escaped with another backslash, therefore, the above will equate to:
/// 
/// The escaped string \\' represents '.
/// The escaped string \\{ represents {.
/// The escaped string \\} represents }.
/// The escaped string \\\\ represents \.
/// 
/// If an open escape backslash \ is found in the Intrinsic Function, the interpreter will throw a runtime error.
string StateIntrinsicFunction
