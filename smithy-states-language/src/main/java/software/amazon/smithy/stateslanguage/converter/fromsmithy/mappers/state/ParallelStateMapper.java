/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state;

import java.util.Map;
import software.amazon.smithy.model.node.ArrayNode;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StatesLanguageConverter;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.MapperUtils;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;

public class ParallelStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.stateslanguage#parallelState")) {
            return objectNode;
        }
        objectNode = MapperUtils.withStateType("Parallel", objectNode);
        objectNode = MapperUtils.withInputPathOutputPath(objectNode);
        objectNode = MapperUtils.withNextOrEnd(objectNode);
        objectNode = MapperUtils.withResultPath(objectNode);
        objectNode = MapperUtils.withRetry(objectNode);
        objectNode = MapperUtils.withCatch(objectNode);
        objectNode = handleBranches(objectNode, context);
        return objectNode;
    }

    private ObjectNode handleBranches(ObjectNode objectNode, Context context) {
        ArrayNode result = ArrayNode.arrayNode();
        for (Node node : objectNode.expectArrayMember("Branches").getElements()) {
            result = result.withValue(handleStateMachine(
                    ShapeId.from(node.expectStringNode().getValue()),
                    context));
        }
        return objectNode.withMember("Branches", result);
    }

    private ObjectNode handleStateMachine(ShapeId stateMachineShapeId, Context context) {
        StateMachineTrait stateMachineTrait = context.getModel()
                .expectShape(stateMachineShapeId)
                .expectTrait(StateMachineTrait.class);
        Map<String, Trait> stateMachineStates = context
                .getStateMachineIndex()
                .getStateMachineStates()
                .get(stateMachineShapeId);
        ObjectNode stateMachineObjectNode = stateMachineTrait.toNode().expectObjectNode();
        stateMachineObjectNode = StatesLanguageConverter.applyStateMachineMappers(stateMachineObjectNode, new Context(
                context.getModel(),
                context.getExtensions(),
                stateMachineStates,
                context.getStateMachineIndex()));
        return ObjectNode.builder()
                .withMember("StartAt", stateMachineObjectNode.expectStringMember("StartAt"))
                .withMember("States", stateMachineObjectNode.expectObjectMember("States"))
                .build();
    }
}
