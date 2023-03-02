$version: "2.0"

namespace batch.job.notification

@externalDocumentation(
    "Documentation": "https://docs.aws.amazon.com/step-functions/latest/dg/batch-job-notification.html"
)
@smithy.stateslanguage#stateMachine(
    comment: "An example of the Amazon States Language for notification on an AWS Batch job completion"
    startAt: "Submit Batch Job"
    timeoutSeconds: 3600
    states: {
        "Submit Batch Job": SubmitBatchJobState
        "Notify Success": NotifySuccessState
        "Notify Failure": NotifyFailureState
    }
)
structure BatchJobNotificationStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::batch:submitJob.sync"
    parameters: {
        "JobName": "BatchJobNotification"
        "JobQueue": "arn:aws:batch:us-east-1:123456789012:job-queue/BatchJobQueue-7049d367474b4dd"
        "JobDefinition": "arn:aws:batch:us-east-1:123456789012:job-definition/BatchJobDefinition-74d55ec34c4643c:1"
    }
    nextOrEnd: { next: "Notify Success" }
    catch: [
        {
            errorEquals: [
                "States.ALL"
            ]
            next: "Notify Failure"
        }
    ]
)
structure SubmitBatchJobState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    parameters: {
        "Message": "Batch job submitted through Step Functions succeeded"
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:batchjobnotificatiointemplate-SNSTopic-1J757CVBQ2KHM"
    }
    nextOrEnd: { end: true }
)
structure NotifySuccessState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    parameters: {
        "Message": "Batch job submitted through Step Functions failed"
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:batchjobnotificatiointemplate-SNSTopic-1J757CVBQ2KHM"
    }
    nextOrEnd: { end: true }
)
structure NotifyFailureState {}
