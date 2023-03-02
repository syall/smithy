$version: "2.0"

namespace smithy.stateslanguage

@trait
@stateDefinition
structure choiceState {
    comment: String
    inputPath: StatePath
    outputPath: StatePath
    // State-specific
    choices: StateChoiceRuleWithNextList
    default: StateName
}

@length(min: 1)
list StateChoiceRuleWithNextList {
    member: StateChoiceRuleWithNext
}

union StateChoiceRuleWithNext {
    booleanExpression: StateBooleanExpressionWithNext
    dataTestExpression: StateDataTestExpressionWithNext
}

structure StateBooleanExpressionWithNext {
    @required
    next: StateName
    and: StateChoiceRuleList
    or: StateChoiceRuleList
    not: StateChoiceRule
}

structure StateDataTestExpressionWithNext {
    @required
    next: StateName
    @required
    variable: StatePath
    @required
    comparisonOperator: StateComparisonOperator
    @required 
    comparisonOperatorValue: StateComparisonOperatorValue
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
    and: StateChoiceRuleList
    or: StateChoiceRuleList
    not: StateChoiceRule
}

structure StateDataTestExpression {
    @required
    variable: StatePath
    @required
    comparisonOperator: StateComparisonOperator
    @required 
    comparisonOperatorValue: StateComparisonOperatorValue
}

string StateComparisonOperator

document StateComparisonOperatorValue
