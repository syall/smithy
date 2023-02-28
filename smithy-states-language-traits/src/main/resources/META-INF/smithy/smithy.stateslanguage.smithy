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

    timeoutSeconds: Integer
}

map States {
    key: StateName
    value: StateIdRef
}

@idRef(failWhenMissing: true, selector: "structure [trait|smithy.stateslanguage#state]")
string StateIdRef

@trait(selector: "structure")
structure state {}

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

@length(min: 1, max: 80)
string StateName

string StatePath

@timestampFormat("date-time")
timestamp StateTimestamp

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
