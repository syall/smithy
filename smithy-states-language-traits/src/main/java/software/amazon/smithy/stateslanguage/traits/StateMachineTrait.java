/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.traits;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.NodeMapper;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.AbstractTrait;
import software.amazon.smithy.model.traits.AbstractTraitBuilder;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.utils.MapUtils;
import software.amazon.smithy.utils.SmithyBuilder;
import software.amazon.smithy.utils.ToSmithyBuilder;

public final class StateMachineTrait extends AbstractTrait implements ToSmithyBuilder<StateMachineTrait> {
    public static final ShapeId ID = ShapeId.from("smithy.stateslanguage#stateMachine");

    private final Map<String, ShapeId> states;
    private final String startAt;
    private final String comment;
    private final String version;
    private final Integer timeoutSeconds;

    private StateMachineTrait(Builder builder) {
        super(ID, builder.getSourceLocation());
        states = MapUtils.copyOf(builder.states);
        startAt = builder.startAt;
        comment = builder.comment;
        version = builder.version;
        timeoutSeconds = builder.timeoutSeconds;
    }

    public Map<String, ShapeId> getStates() {
        return states;
    }

    public String getStartAt() {
        return startAt;
    }

    public Optional<String> getComment() {
        return Optional.ofNullable(comment);
    }

    public String getVersion() {
        return version;
    }

    public Optional<Integer> getTimeoutSeconds() {
        return Optional.ofNullable(timeoutSeconds);
    }

    public static Builder builder() {
        return new Builder();
    }

    @Override
    protected Node createNode() {
        NodeMapper mapper = new NodeMapper();
        mapper.disableToNodeForClass(StateMachineTrait.class);
        mapper.setOmitEmptyValues(true);
        return mapper.serialize(this).expectObjectNode();
    }

    @Override
    public SmithyBuilder<StateMachineTrait> toBuilder() {
        return builder()
                .states(states)
                .startAt(startAt)
                .comment(comment)
                .version(version)
                .timeoutSeconds(timeoutSeconds);
    }

    public static final class Provider extends AbstractTrait.Provider {
        public Provider() {
            super(ID);
        }

        @Override
        public Trait createTrait(ShapeId target, Node value) {
            StateMachineTrait result = new NodeMapper().deserialize(value, StateMachineTrait.class);
            result.setNodeCache(value);
            return result;
        }
    }

    public static final class Builder extends AbstractTraitBuilder<StateMachineTrait, Builder> {
        private Map<String, ShapeId> states = new LinkedHashMap<>();
        private String startAt;
        private String comment;
        private String version = "1.0";
        private Integer timeoutSeconds;

        private Builder() {
        }

        @Override
        public StateMachineTrait build() {
            return new StateMachineTrait(this);
        }

        public Builder states(Map<String, ShapeId> states) {
            this.states.clear();
            this.states.putAll(states);
            return this;
        }

        public Builder startAt(String startAt) {
            this.startAt = startAt;
            return this;
        }

        public Builder comment(String comment) {
            this.comment = comment;
            return this;
        }

        public Builder version(String version) {
            this.version = version;
            return this;
        }

        public Builder timeoutSeconds(Integer timeoutSeconds) {
            this.timeoutSeconds = timeoutSeconds;
            return this;
        }
    }
}
