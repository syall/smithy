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

public final class WaitStateTrait extends AbstractTrait implements ToSmithyBuilder<WaitStateTrait> {
    public static final ShapeId ID = ShapeId.from("smithy.stateslanguage#waitState");
    public static final String TYPE = "Wait";

    private final String comment;
    private final String inputPath;
    private final String outputPath;

    private WaitStateTrait(Builder builder) {
        super(ID, builder.getSourceLocation());
        comment = builder.comment;
        inputPath = builder.inputPath;
        outputPath = builder.outputPath;
    }

    public static Builder builder() {
        return new Builder();
    }

    @Override
    protected Node createNode() {
        NodeMapper mapper = new NodeMapper();
        mapper.disableToNodeForClass(WaitStateTrait.class);
        mapper.setOmitEmptyValues(true);
        return mapper.serialize(this).expectObjectNode();
    }

    @Override
    public SmithyBuilder<WaitStateTrait> toBuilder() {
        return builder()
            .comment(comment)
            .inputPath(inputPath)
            .outputPath(outputPath);
    }

    public static final class Provider extends AbstractTrait.Provider {
        public Provider() {
            super(ID);
        }

        @Override
        public Trait createTrait(ShapeId target, Node value) {
            WaitStateTrait result = new NodeMapper().deserialize(value, WaitStateTrait.class);
            result.setNodeCache(value);
            return result;
        }
    }

    public static final class Builder extends AbstractTraitBuilder<WaitStateTrait, Builder> {
        private String comment;
        private String inputPath;
        private String outputPath;

        private Builder() {
        }

        @Override
        public WaitStateTrait build() {
            return new WaitStateTrait(this);
        }

        public Builder comment(String comment) {
            this.comment = comment;
            return this;
        }

        public Builder inputPath(String inputPath) {
            this.inputPath = inputPath;
            return this;
        }

        public Builder outputPath(String outputPath) {
            this.outputPath = outputPath;
            return this;
        }
    }
}
