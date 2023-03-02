$version: "2.0"

namespace run.multiple.queries

@externalDocumentation(
    "Documentation": "https://docs.aws.amazon.com/step-functions/latest/dg/run-multiple-queries.html"
)
@smithy.stateslanguage#stateMachine(
    comment: "An example of using Athena to execute queries in sequence and parallel, with error handling and notifications."
    startAt: "Generate Example Data"
    states: {
        "Generate Example Data": GenerateExampleDataState
        "Load Data to Database": LoadDataToDatabaseState
        "Map": MapState
        "Send query results": SendQueryResultsState
    }
)
structure RunMultipleQueriesStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::lambda:invoke"
    outputPath: "$.Payload"
    parameters: {
        "FunctionName": "<ATHENA_FUNCTION_NAME>"
    }
    nextOrEnd: { next: "Load Data to Database" }
)
structure GenerateExampleDataState {}

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

@smithy.stateslanguage#state(definition: smithy.stateslanguage#parallelState)
@smithy.stateslanguage#parallelState(
    resultSelector: {
        "Query1Result.$": "$[0].ResultSet.Rows"
        "Query2Result.$": "$[1].ResultSet.Rows"
    }
    catch: [
        {
            errorEquals: [
                "States.ALL"
            ]
            next: "Send query results"
        }
    ]
    branches: [
        MapStateAthenaQuery1StateMachine
        MapStateAthenaQuery2StateMachine
    ]
    nextOrEnd: { next: "Send query results" }
)
structure MapState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    parameters: {
        "Message.$": "$"
        "TopicArn": "<SNS_TOPIC_ARN>"
    }
    nextOrEnd: { end: true }
)
structure SendQueryResultsState {}

@smithy.stateslanguage#stateMachine(
    startAt: "Start Athena query 1"
    states: {
        "Start Athena query 1": StartAthenaQuery1State
        "Get Athena query 1 results": GetAthenaQuery1ResultsState
    }
)
structure MapStateAthenaQuery1StateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:startQueryExecution.sync"
    parameters: {
        "QueryString": "<ATHENA_QUERYSTRING>"
        "WorkGroup": "<ATHENA_WORKGROUP>"
    }
    nextOrEnd: { next: "Get Athena query 1 results" }
)
structure StartAthenaQuery1State {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:getQueryResults"
    parameters: {
        "QueryExecutionId.$": "$.QueryExecution.QueryExecutionId"
    }
    nextOrEnd: { end: true }
)
structure GetAthenaQuery1ResultsState {}

@smithy.stateslanguage#stateMachine(
    startAt: "Start Athena query 2"
    states: {
        "Start Athena query 2": StartAthenaQuery2State
        "Get Athena query 2 results": GetAthenaQuery2ResultsState
    }
)
structure MapStateAthenaQuery2StateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:startQueryExecution.sync"
    parameters: {
        "QueryString": "<ATHENA_QUERYSTRING>"
        "WorkGroup": "<ATHENA_WORKGROUP>"
    }
    nextOrEnd: { next: "Get Athena query 2 results" }
)
structure StartAthenaQuery2State {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:getQueryResults"
    parameters: {
        "QueryExecutionId.$": "$.QueryExecution.QueryExecutionId"
    }
    nextOrEnd: { end: true }
)
structure GetAthenaQuery2ResultsState {}
