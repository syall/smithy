/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.statemachine;

import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Context;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMachineMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StatesLanguageConverter;

public class ApplyStateMappersMapper implements StateMachineMapper {
    @Override
    public ObjectNode updateNode(Context context, ObjectNode objectNode) {
        ObjectNode stateMachineStatesObjectNode = ObjectNode.objectNode();
        stateMachineStatesObjectNode = StatesLanguageConverter.applyStateMappers(stateMachineStatesObjectNode, context);
        return objectNode.withMember("States", stateMachineStatesObjectNode);
    }
}
