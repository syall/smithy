/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.traits;

import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.NodeMapper;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.AbstractTrait;
import software.amazon.smithy.model.traits.AbstractTraitBuilder;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.utils.SmithyBuilder;
import software.amazon.smithy.utils.ToSmithyBuilder;

public final class StateTrait extends AbstractTrait implements ToSmithyBuilder<StateTrait> {
    public static final ShapeId ID = ShapeId.from("smithy.stateslanguage#state");

    private final ShapeId definition;

    private StateTrait(Builder builder) {
        super(ID, builder.getSourceLocation());
        this.definition = builder.definition;
    }

    public ShapeId getDefinition() {
        return definition;
    }

    public static Builder builder() {
        return new Builder();
    }

    @Override
    protected Node createNode() {
        NodeMapper mapper = new NodeMapper();
        mapper.disableToNodeForClass(StateTrait.class);
        mapper.setOmitEmptyValues(true);
        return mapper.serialize(this).expectObjectNode();
    }

    @Override
    public SmithyBuilder<StateTrait> toBuilder() {
        return builder()
                .definition(definition);
    }

    public static final class Provider extends AbstractTrait.Provider {
        public Provider() {
            super(ID);
        }

        @Override
        public Trait createTrait(ShapeId target, Node value) {
            StateTrait result = new NodeMapper().deserialize(value, StateTrait.class);
            result.setNodeCache(value);
            return result;
        }
    }

    public static final class Builder extends AbstractTraitBuilder<StateTrait, Builder> {
        private ShapeId definition;

        private Builder() {
        }

        public Builder definition(ShapeId definition) {
            this.definition = definition;
            return this;
        }

        @Override
        public StateTrait build() {
            return new StateTrait(this);
        }
    }
}
