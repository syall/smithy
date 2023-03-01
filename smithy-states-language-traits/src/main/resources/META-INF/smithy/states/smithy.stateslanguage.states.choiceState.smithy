$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure choiceState {
    comment: String
    inputPath: StatePath
    outputPath: StatePath
    // State-specific
    choices: StateChoiceRuleList
    default: StateName
}

@length(min: 1)
list StateChoiceRuleList {
    member: StateChoiceRule
}

union StateChoiceRule {
    booleanExpression: StateBooleanExpression
    dataTestExpression: StateDataTestExpression
}

structure StateBooleanExpression {
    next: StateName
    and: StateChoiceRuleList
    or: StateChoiceRuleList
    not: StateChoiceRule
}

structure StateDataTestExpression {
    next: StateName
    @required
    variable: StatePath
    @required
    comparisonOperator: StateComparisonOperator
    @required 
    comparisonOperatorValue: StateComparisonOperatorValue
}

string StateComparisonOperator

document StateComparisonOperatorValue
