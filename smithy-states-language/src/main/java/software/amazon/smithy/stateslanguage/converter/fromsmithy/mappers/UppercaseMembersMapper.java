/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers;

import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMachineMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;

public class UppercaseMembersMapper implements StateMapper, StateMachineMapper {
    @Override
    public byte getOrder() {
        return 0;
    }

    @Override
    public ObjectNode updateNode(Context context, Trait trait, ObjectNode objectNode) {
        return MapperUtils.withUppercaseFirstLetterMembers(objectNode);
    }

    @Override
    public ObjectNode updateNode(Context context, ObjectNode objectNode) {
        return MapperUtils.withUppercaseFirstLetterMembers(objectNode);
    }
}
