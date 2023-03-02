/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state;

import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.MapperUtils;

public class WaitStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.stateslanguage#waitState")) {
            return objectNode;
        }
        objectNode = MapperUtils.withStateType("Wait", objectNode);
        objectNode = MapperUtils.withNextOrEnd(objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("Seconds", objectNode);
        objectNode = MapperUtils.withMemberOrStatePath("Timestamp", objectNode);
        return objectNode;
    }
}
