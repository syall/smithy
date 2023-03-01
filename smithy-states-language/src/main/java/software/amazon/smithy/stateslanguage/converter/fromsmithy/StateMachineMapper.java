/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;

public interface StateMachineMapper {
    default byte getOrder() {
        return 0;
    }

    default ObjectNode updateNode(Context context, StateMachineTrait trait, ObjectNode objectNode) {
        return objectNode;
    }
}
