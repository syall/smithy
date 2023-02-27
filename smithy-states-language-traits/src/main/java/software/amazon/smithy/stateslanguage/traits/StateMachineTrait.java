/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.traits;

import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.AnnotationTrait;

public final class StateMachineTrait extends AnnotationTrait {
    public static final ShapeId ID = ShapeId.from("smithy.stateslanguage#stateMachine");

    public StateMachineTrait(ObjectNode node) {
        super(ID, node);
    }

    public StateMachineTrait() {
        this(Node.objectNode());
    }

    public static final class Provider extends AnnotationTrait.Provider<StateMachineTrait> {
        public Provider() {
            super(ID, StateMachineTrait::new);
        }
    }
}
