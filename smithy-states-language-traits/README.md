# Smithy States Language traits

This module provides the implementation of States Language traits for Smithy.

See the [Amazon States Language specification](https://states-language.net/spec.html).

TODO List:

- Validators
    - stateMachine
    - state
    - StateName
    - StateURI
      - Custom lambda validation
      - Custom AWS SDK validation
    - StatePath
    - StateTimestamp
    - StatePayloadTemplate
    - StateRetry
    - StateCatch
    - StateBranchList
    - StateBranch
    - StateItemProcessor
    - StateItemReader
    - StateItemBatcher
    - StateResultWriter
    - StateChoiceRuleList
    - StateChoiceRule
    - StateBooleanExpression
    - StateBooleanExpressionEvaluation
    - StateDataTestExpression
    - StateComparisonOperator
    - StateComparisonOperatorValue
    - Overall either-or path uniqueness
- Converting to Amazon States Language `*.asl.json`
    - Convert field names to camel-case
    - Convert examples from https://docs.aws.amazon.com/step-functions/latest/dg/create-sample-projects.html
    - awslabs/statelint integration? https://github.com/awslabs/statelint
