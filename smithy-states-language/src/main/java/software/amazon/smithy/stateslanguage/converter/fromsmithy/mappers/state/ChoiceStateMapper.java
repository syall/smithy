/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state;

import software.amazon.smithy.model.node.ArrayNode;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.node.StringNode;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.MapperUtils;

public class ChoiceStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.stateslanguage#choiceState")) {
            return objectNode;
        }
        objectNode = MapperUtils.withStateType("Choice", objectNode);
        ArrayNode newChoicesNode = handleStateChoiceRuleList("Choices", objectNode);
        return objectNode.withMember("Choices", newChoicesNode);
    }

    private ArrayNode handleStateChoiceRuleList(
            String memberName,
            ObjectNode objectNode) {
        ArrayNode result = ArrayNode.arrayNode();
        for (Node node : objectNode.expectArrayMember(memberName).getElements()) {
            result = result.withValue(handleStateChoiceRule(node.expectObjectNode()));
        }
        return result;
    }

    private ObjectNode handleStateChoiceRule(ObjectNode stateChoiceRule) {
        if (stateChoiceRule.containsMember("booleanExpression")) {
            return handleBooleanExpression(stateChoiceRule);
        } else if (stateChoiceRule.containsMember("dataTestExpression")) {
            return handleDataTestExpression(stateChoiceRule);
        }
        throw new RuntimeException("Choice rule type not implemented: `"
                + Node.prettyPrintJson(stateChoiceRule) + "`");
    }

    private ObjectNode handleBooleanExpression(ObjectNode stateChoiceRule) {
        stateChoiceRule = MapperUtils.uppercaseFirstLetterMembers(
            stateChoiceRule.expectObjectMember("booleanExpression"));
        if (stateChoiceRule.containsMember("And")) {
            return stateChoiceRule.withMember("And",
                    handleStateChoiceRuleList("And", stateChoiceRule));
        } else if (stateChoiceRule.containsMember("Or")) {
            return stateChoiceRule.withMember("Or",
                    handleStateChoiceRuleList("Or", stateChoiceRule));
        } else if (stateChoiceRule.containsMember("Not")) {
            return stateChoiceRule.withMember("Not",
                    handleStateChoiceRule(stateChoiceRule));
        }
        throw new RuntimeException("Boolean expression type not implemented: `"
                + Node.prettyPrintJson(stateChoiceRule) + "`");
    }

    private ObjectNode handleDataTestExpression(ObjectNode stateChoiceRule) {
        stateChoiceRule = MapperUtils.uppercaseFirstLetterMembers(
            stateChoiceRule.expectObjectMember("dataTestExpression"));
        StringNode comparisonOperator = stateChoiceRule.expectStringMember("ComparisonOperator");
        stateChoiceRule = stateChoiceRule.withoutMember("ComparisonOperator");
        Node comparisonOperatorValue = stateChoiceRule.expectMember("ComparisonOperatorValue");
        stateChoiceRule = stateChoiceRule.withoutMember("ComparisonOperatorValue");
        return stateChoiceRule.withMember(comparisonOperator, comparisonOperatorValue);
    }
}
