$version: "2.0"

namespace codebuild.example

@externalDocumentation(
    "Documentation": "https://docs.aws.amazon.com/step-functions/latest/dg/sample-project-codebuild.html"
)
@smithy.stateslanguage#stateMachine(
    states: {
        "Trigger CodeBuild Build": TriggerCodeBuildBuildState
        "Get Test Results": GetTestResultsState
        "All Tests Passed?": AllTestsPassedState
        "Notify Success": NotifySuccessState
        "Notify Failure": NotifyFailureState
    }
    startAt: "Trigger CodeBuild Build"
    comment: "An example of using CodeBuild to run tests, get test results and send a notification."
)
structure CodeBuildStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::codebuild:startBuild.sync"
    parameters: {
        "ProjectName": "CodeBuildProject-Dtw1jBhEYGDf"
    }
    nextOrEnd: { next: "Get Test Results" }
)
structure TriggerCodeBuildBuildState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::codebuild:batchGetReports"
    parameters: {
        "ReportArns.$": "$.Build.ReportArns"
    }
    nextOrEnd: { next: "All Tests Passed?" }
)
structure GetTestResultsState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#choiceState)
@smithy.stateslanguage#choiceState(
    choices: [
        {
            dataTestExpression: {
                variable: "$.Reports[0].Status"
                comparisonOperator: "StringEquals"
                comparisonOperatorValue: "SUCCEEDED"
                next: "NotifySuccess"
            }
        }
    ]
    default: "Notify Failure"
)
structure AllTestsPassedState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    parameters: {
        "Message": "CodeBuild build tests succeeded",
        "TopicArn": "arn:aws:sns:sa-east-1:123456789012:StepFunctionsSample-CodeBuildExecution3da9ead6-bc1f-4441-99ac-591c140019c4-SNSTopic-EVYLVNGW85JP"
    }
    nextOrEnd: { end: true }
)
structure NotifySuccessState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    parameters: {
        "Message": "CodeBuild build tests failed",
        "TopicArn": "arn:aws:sns:sa-east-1:123456789012:StepFunctionsSample-CodeBuildExecution3da9ead6-bc1f-4441-99ac-591c140019c4-SNSTopic-EVYLVNGW85JP"
    }
    nextOrEnd: { end: true }
)
structure NotifyFailureState {}
