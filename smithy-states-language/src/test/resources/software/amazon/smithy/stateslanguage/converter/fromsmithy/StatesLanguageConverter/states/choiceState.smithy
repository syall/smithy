$version: "2.0"

namespace test.choiceState

@smithy.stateslanguage#stateMachine(
    startAt: "State"
    states: {
        "State": TestState
        "NextState": NextTestState
    }
)
structure TestStateMachine {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#choiceState)
@smithy.stateslanguage#choiceState(
    comment: "COMMENT"
    inputPath: { path: "$" }
    outputPath: { null: true }
    choices: [
        {
            booleanExpression: {
                next: "NextState"
                not: {
                    booleanExpression: {
                        or: [
                            {
                                dataTestExpression: {
                                    variable: "$"
                                    comparisonOperator: "StringEquals"
                                    comparisonOperatorValue: "TEST"
                                }
                            }
                            {
                                booleanExpression: {
                                    and: [
                                        {
                                            dataTestExpression: {
                                                variable: "$"
                                                comparisonOperator: "NumericEquals"
                                                comparisonOperatorValue: 0
                                            }
                                        }
                                        {
                                            dataTestExpression: {
                                                variable: "$"
                                                comparisonOperator: "StringEqualsPath"
                                                comparisonOperatorValue: "$"
                                            }
                                        }
                                    ]
                                }
                            }
                        ]
                    }
                }
            }
        }
        {
            dataTestExpression: {
                next: "NextState"
                variable: "$"
                comparisonOperator: "IsNull"
                comparisonOperatorValue: true
            }
        }
    ]
    default: "NextState"
)
structure TestState {}

@smithy.stateslanguage#state(definition: smithy.stateslanguage#succeedState)
@smithy.stateslanguage#succeedState()
structure NextTestState {}
