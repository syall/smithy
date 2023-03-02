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

public class SucceedStateMapper implements StateMapper {
    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        if (!trait.toShapeId().toString().equals("smithy.stateslanguage#succeedState")) {
            return objectNode;
        }
        objectNode = MapperUtils.withInputPathOutputPath(objectNode);
        return MapperUtils.withStateType("Succeed", objectNode);
    }
}
