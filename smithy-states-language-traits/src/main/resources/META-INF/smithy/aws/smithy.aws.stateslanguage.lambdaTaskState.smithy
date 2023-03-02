$version: "2.0"

namespace smithy.aws.stateslanguage

use smithy.stateslanguage#stateDefinition
use smithy.stateslanguage#StatePathOrNull
use smithy.stateslanguage#StateNextOrEnd
use smithy.stateslanguage#StatePayloadTemplate
use smithy.stateslanguage#StateRetry
use smithy.stateslanguage#StateCatch
use smithy.stateslanguage#TimeoutSecondsOrStatePath
use smithy.stateslanguage#HeartbeatSecondsOrStatePath
use smithy.stateslanguage#PositiveInteger
use smithy.stateslanguage#StatePath

@trait
@stateDefinition
structure lambdaTaskState {
    comment: String
    inputPath: StatePathOrNull
    outputPath: StatePathOrNull
    @required
    nextOrEnd: StateNextOrEnd
    resultPath: StatePathOrNull
    parameters: StatePayloadTemplate
    resultSelector: StatePayloadTemplate
    retry: StateRetry
    catch: StateCatch
    // State-specific
    @required
    resource: AwsLambdaResource
    timeoutSeconds: TimeoutSecondsOrStatePath
    heartbeatSeconds: HeartbeatSecondsOrStatePath
    credentials: StatePayloadTemplate
}

/// Format: arn:aws:lambda:{region}:{accountId}:function:{functionName}
structure AwsLambdaResource {
    @required
    region: String
    @required
    accountId: String
    @required
    functionName: String
}
