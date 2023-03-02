/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.traits.states;

import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.NodeMapper;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.AbstractTrait;
import software.amazon.smithy.model.traits.AbstractTraitBuilder;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.utils.SmithyBuilder;
import software.amazon.smithy.utils.ToSmithyBuilder;

public final class FailStateTrait extends AbstractTrait implements ToSmithyBuilder<FailStateTrait> {
    public static final ShapeId ID = ShapeId.from("smithy.stateslanguage#failState");
    public static final String TYPE = "Fail";

    private final String comment;
    private final String error;
    private final String cause;

    private FailStateTrait(Builder builder) {
        super(ID, builder.getSourceLocation());
        comment = builder.comment;
        error = builder.error;
        cause = builder.cause;
    }

    public static Builder builder() {
        return new Builder();
    }

    @Override
    protected Node createNode() {
        NodeMapper mapper = new NodeMapper();
        mapper.disableToNodeForClass(FailStateTrait.class);
        mapper.setOmitEmptyValues(true);
        return mapper.serialize(this).expectObjectNode();
    }

    @Override
    public SmithyBuilder<FailStateTrait> toBuilder() {
        return builder()
                .comment(comment)
                .error(error)
                .cause(cause);
    }

    public static final class Provider extends AbstractTrait.Provider {
        public Provider() {
            super(ID);
        }

        @Override
        public Trait createTrait(ShapeId target, Node value) {
            FailStateTrait result = new NodeMapper().deserialize(value, FailStateTrait.class);
            result.setNodeCache(value);
            return result;
        }
    }

    public static final class Builder extends AbstractTraitBuilder<FailStateTrait, Builder> {
        private String comment;
        private String error;
        private String cause;

        private Builder() {
        }

        @Override
        public FailStateTrait build() {
            return new FailStateTrait(this);
        }

        public Builder comment(String comment) {
            this.comment = comment;
            return this;
        }

        public Builder error(String error) {
            this.error = error;
            return this;
        }

        public Builder cause(String cause) {
            this.cause = cause;
            return this;
        }
    }
}
