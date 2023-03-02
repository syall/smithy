/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state;

import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.node.StringNode;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.MapperUtils;

public class AwsLambdaTaskStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.aws.stateslanguage#lambdaTaskState")) {
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
        ObjectNode awsLambdaResourceNode = objectNode.expectObjectMember("Resource");
        String awsLambdaResource = "arn:aws:lambda:"
                + awsLambdaResourceNode.expectStringMember("region").getValue() + ":"
                + awsLambdaResourceNode.expectStringMember("accountId").getValue() + ":function:"
                + awsLambdaResourceNode.expectStringMember("functionName").getValue();
        return objectNode.withMember("Resource", StringNode.from(awsLambdaResource));
    }
}
