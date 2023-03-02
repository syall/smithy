/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state;

import software.amazon.smithy.aws.traits.ServiceTrait;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.node.StringNode;
import software.amazon.smithy.model.shapes.ServiceShape;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageException;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.MapperUtils;

public class AwsSdkTaskStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.aws.stateslanguage#sdkTaskState")) {
            return objectNode;
        }
        objectNode = MapperUtils.withStateType("Task", objectNode);
        objectNode = MapperUtils.withInputPathOutputPath(objectNode);
        objectNode = MapperUtils.withNextOrEnd(objectNode);
        objectNode = MapperUtils.withResultPath(objectNode);
        objectNode = MapperUtils.withRetry(objectNode);
        objectNode = MapperUtils.withCatch(objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("TimeoutSeconds", objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("HeartbeatSeconds", objectNode);
        ObjectNode awsSdkResourceNode = objectNode.expectObjectMember("Resource");
        ShapeId serviceShapeId = ShapeId.from(awsSdkResourceNode
                .expectStringMember("service")
                .getValue());
        ServiceShape serviceShape = context
                .getModel()
                .expectShape(serviceShapeId)
                .asServiceShape()
                .get();
        String serviceArnNamespace = serviceShape
                .expectTrait(ServiceTrait.class)
                .toNode()
                .expectObjectNode()
                .expectStringMember("arnNamespace")
                .getValue();
        ShapeId operationShapeId = ShapeId.from(awsSdkResourceNode
                .expectStringMember("operation")
                .getValue());
        Boolean isOperationInService = serviceShape.getAllOperations().stream()
                .anyMatch(opId -> opId.equals(operationShapeId));
        if (!isOperationInService) {
            throw new StatesLanguageException(
                    "Operation `" + operationShapeId + "` must be bound to the"
                            + "service `" + serviceShapeId + "` in an AWS SDK Task State");
        }
        String operationName = operationShapeId.getName().substring(0, 1).toLowerCase()
                + operationShapeId.getName().substring(1);
        String awsSdkResource = "arn:aws:states:::"
                + serviceArnNamespace + ":"
                + operationName;
        if (awsSdkResourceNode.containsMember("isSync")) {
            if (awsSdkResourceNode.expectBooleanMember("isSync").getValue()) {
                awsSdkResource = awsSdkResource + ".sync";
            }
        }
        return objectNode.withMember("Resource", StringNode.from(awsSdkResource));
    }
}
