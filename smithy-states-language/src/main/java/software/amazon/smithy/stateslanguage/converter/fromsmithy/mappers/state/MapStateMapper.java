/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state;

import java.util.Map;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StatesLanguageConverter;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.MapperUtils;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;

public class MapStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.stateslanguage#mapState")) {
            return objectNode;
        }
        objectNode = MapperUtils.withStateType("Map", objectNode);
        objectNode = MapperUtils.withInputPathOutputPath(objectNode);
        objectNode = MapperUtils.withNextOrEnd(objectNode);
        objectNode = MapperUtils.withResultPath(objectNode);
        objectNode = MapperUtils.withRetry(objectNode);
        objectNode = MapperUtils.withCatch(objectNode);
        objectNode = handleItemProcessor(objectNode, context);
        objectNode = handleItemReader(objectNode);
        objectNode = handleItemBatcher(objectNode);
        objectNode = handleResultWriter(objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("MaxConcurrency", objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("ToleratedFailurePercentage", objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("ToleratedFailureCount", objectNode);
        return objectNode;
    }

    private ObjectNode handleItemProcessor(ObjectNode objectNode, Context context) {
        ObjectNode itemProcessorNode = objectNode.expectObjectMember("ItemProcessor");
        itemProcessorNode = MapperUtils.withUppercaseFirstLetterMembers(itemProcessorNode);
        itemProcessorNode = handleStateMachine(itemProcessorNode, context);
        return objectNode.withMember("ItemProcessor", itemProcessorNode);
    }

    private ObjectNode handleStateMachine(ObjectNode objectNode, Context context) {
        ShapeId stateMachineShapeId = ShapeId.from(objectNode.expectStringMember("StateMachine").getValue());
        objectNode = objectNode.withoutMember("StateMachine");
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
        objectNode = objectNode.withMember("StartAt", stateMachineObjectNode.expectStringMember("StartAt"));
        objectNode = objectNode.withMember("States", stateMachineObjectNode.expectObjectMember("States"));
        return objectNode;
    }

    private ObjectNode handleItemReader(ObjectNode objectNode) {
        if (!objectNode.containsMember("ItemReader")) {
            return objectNode;
        }
        ObjectNode itemReaderNode = objectNode.expectObjectMember("ItemReader");
        itemReaderNode = MapperUtils.withUppercaseFirstLetterMembers(itemReaderNode);
        itemReaderNode = handleReaderConfig(itemReaderNode);
        return objectNode.withMember("ItemReader", itemReaderNode);
    }

    private ObjectNode handleReaderConfig(ObjectNode objectNode) {
        if (!objectNode.containsMember("ReaderConfig")) {
            return objectNode;
        }
        ObjectNode readerConfigNode = objectNode.expectObjectMember("ReaderConfig");
        readerConfigNode = MapperUtils.withUppercaseFirstLetterMembers(readerConfigNode);
        readerConfigNode = MapperUtils.withMemberOrStatePath("MaxItems", readerConfigNode);
        return objectNode.withMember("ReaderConfig", readerConfigNode);
    }

    private ObjectNode handleItemBatcher(ObjectNode objectNode) {
        if (!objectNode.containsMember("ItemBatcher")) {
            return objectNode;
        }
        ObjectNode itemBatcherNode = objectNode.expectObjectMember("ItemBatcher");
        itemBatcherNode = MapperUtils.withUppercaseFirstLetterMembers(itemBatcherNode);
        itemBatcherNode = MapperUtils.withMemberOrStatePath("MaxItemsPerBatch", itemBatcherNode);
        itemBatcherNode = MapperUtils.withMemberOrStatePath("MaxInputBytesPerBatch", itemBatcherNode);
        return objectNode.withMember("ItemBatcher", itemBatcherNode);
    }

    ObjectNode handleResultWriter(ObjectNode objectNode) {
        if (!objectNode.containsMember("ResultWriter")) {
            return objectNode;
        }
        return objectNode.withMember("ResultWriter",
                MapperUtils.withUppercaseFirstLetterMembers(objectNode.expectObjectMember("ResultWriter")));
    }
}
