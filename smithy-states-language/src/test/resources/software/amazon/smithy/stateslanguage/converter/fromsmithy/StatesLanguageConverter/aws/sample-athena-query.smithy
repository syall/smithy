$version: "2.0"

namespace sample.athena.query

@externalDocumentation(
    "Documentation": "https://docs.aws.amazon.com/step-functions/latest/dg/sample-athena-query.html"
)
@smithy.stateslanguage#stateMachine(
    startAt: "Generate example log"
    states: {
        "Generate example log": GenerateExampleLogState
        "Run Glue crawler": RunGlueCrawlerState
        "Start an Athena query": StartAnAthenaQueryState
        "Get query results": GetQueryResultsState
        "Send query results": SendQueryResultsState
    }
)
structure RunMultipleQueriesStateMachine {}

@smithy.stateslanguage#state(definition: smithy.aws.stateslanguage#lambdaTaskState)
@smithy.aws.stateslanguage#lambdaTaskState(
    resource: {
        region: "us-east-1"
        accountId: "111122223333"
        functionName: "StepFunctionsSample-Athena-LambdaForDataGeneration-AKIAIOSFODNN7EXAMPLE"
    }
    nextOrEnd: { next: "Run Glue crawler" }
)
structure GenerateExampleLogState {}

@smithy.stateslanguage#state(definition: smithy.aws.stateslanguage#lambdaTaskState)
@smithy.aws.stateslanguage#lambdaTaskState(
    resource: {
        region: "us-east-1"
        accountId: "111122223333"
        functionName: "StepFunctionsSample-Athen-LambdaForInvokingCrawler-AKIAI44QH8DHBEXAMPLE"
    }
    nextOrEnd: { next: "Start an Athena query" }
)
structure RunGlueCrawlerState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:startQueryExecution.sync"
    parameters: {
        "QueryString": "SELECT * FROM \"athena-sample-project-db-wJalrXUtnFEMI\".\"log\" limit 1"
        "WorkGroup": "stepfunctions-athena-sample-project-workgroup-wJalrXUtnFEMI"
    }
    nextOrEnd: { next: "Get query results" }
)
structure StartAnAthenaQueryState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::athena:getQueryResults"
    parameters: {
        "QueryExecutionId.$": "$.QueryExecution.QueryExecutionId"
    }
    nextOrEnd: { next: "Send query results" }
)
structure GetQueryResultsState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#taskState)
@smithy.stateslanguage#taskState(
    resource: "arn:aws:states:::sns:publish"
    parameters: {
        "TopicArn": "arn:aws:sns:us-east-1:111122223333:StepFunctionsSample-AthenaDataQueryd1111-2222-3333-777788889999-SNSTopic-ANPAJ2UCCR6DPCEXAMPLE"
        "Message": {
          "Input.$": "$.ResultSet.Rows"
        }
    }
    nextOrEnd: { end: true }
)
structure SendQueryResultsState {}
