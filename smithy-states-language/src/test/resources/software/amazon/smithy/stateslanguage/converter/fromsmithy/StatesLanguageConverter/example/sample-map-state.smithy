$version: "2.0"

namespace sample.map.state

@externalDocumentation(
    "Documentation": "https://docs.aws.amazon.com/step-functions/latest/dg/sample-map-state.html"
)
@smithy.stateslanguage#stateMachine(
    comment: "An example of the Amazon States Language for reading messages from an SQS queue and iteratively processing each message."
    startAt: "Read messages from SQS Queue"
    states: {
        "Read messages from SQS Queue": ReadMessagesFromSQSQueueState
        "Are there messages to process?": AreThereMessagesToProcessState
        "Process messages": ProcessMessagesState
        "Finish": FinishState
    }
)
structure SampleMapStateStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::lambda:invoke"
    outputPath: { path: "$.Payload" }
    parameters: {
        "FunctionName": "MapSampleProj-ReadFromSQSQueueLambda-1MY3M63RMJVA9"
    }
    nextOrEnd: { next: "Are there messages to process?" }
)
structure ReadMessagesFromSQSQueueState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#choiceState)
@smithy.stateslanguage#choiceState(
    choices: [
        {
            dataTestExpression: {
                variable: "$"
                comparisonOperator: "StringEquals"
                comparisonOperatorValue: "No messages"
                next: "Finish"
            }
        }
    ]
    default: "Process messages"
)
structure AreThereMessagesToProcessState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:startQueryExecution.sync"
    parameters: {
        "QueryString": "<ATHENA_QUERYSTRING>"
        "WorkGroup": "<ATHENA_WORKGROUP>"
    }
    catch: [
        {
            errorEquals: [
                "States.ALL"
            ]
            next: "Send query results"
        }
    ]
    nextOrEnd: { next: "Map" }
)
structure LoadDataToDatabaseState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#mapState)
@smithy.stateslanguage#mapState(
    nextOrEnd: { next: "Finish" }
    itemsPath: "$"
    parameters: {
        "MessageNumber.$": "$$.Map.Item.Index"
        "MessageDetails.$": "$$.Map.Item.Value"
    }
    // Changed from deprecated "Iterator" to "ItemProcessor"
    itemProcessor: {
        stateMachine: ProcessMessagesStateMachine
    }
)
structure ProcessMessagesState {}

@smithy.stateslanguage#stateMachine(
    startAt: "Write message to DynamoDB"
    states: {
        "Write message to DynamoDB": WriteMessageToDynamoDbState
        "Remove message from SQS queue": RemoveMessageFromSQSQueueState
        "Publish message to SNS topic": PublishMessageToSNSTopicState
    }
)
structure ProcessMessagesStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::dynamodb:putItem"
    resultPath: { "null": true }
    parameters: {
        "TableName": "MapSampleProj-DDBTable-YJDJ1MKIN6C5"
        "ReturnConsumedCapacity": "TOTAL"
        "Item": {
            "MessageId": {
                "S.$": "$.MessageDetails.MessageId"
            }
            "Body": {
                "S.$": "$.MessageDetails.Body"
            }
        }
    }
    nextOrEnd: { next: "Remove message from SQS queue" }
)
structure WriteMessageToDynamoDbState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::lambda:invoke"
    inputPath: { path: "$.MessageDetails" }
    resultPath: { "null": true }
    parameters: {
        "FunctionName": "MapSampleProj-DeleteFromSQSQueueLambda-198J2839ZO5K2"
        "Payload": {
            "ReceiptHandle.$": "$.ReceiptHandle"
        }
    }
    nextOrEnd: { next: "Publish message to SNS topic" }
)
structure RemoveMessageFromSQSQueueState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    inputPath: { path: "$.MessageDetails" }
    parameters: {
        "Subject": "Message from Step Functions!"
        "Message.$": "$.Body"
        "TopicArn": "arn:aws:sns:us-east-1:012345678910:MapSampleProj-SNSTopic-1CQO4HQ3IR1KN"
    }
    nextOrEnd: { end: true }
)
structure PublishMessageToSNSTopicState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#succeedState)
@smithy.stateslanguage#succeedState
structure FinishState {}
