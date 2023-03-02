/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.ServiceLoader;
import java.util.Set;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.Shape;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageConfig;
import software.amazon.smithy.stateslanguage.converter.knowledge.StateMachineIndex;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;

public final class StatesLanguageConverter {
    private ClassLoader classLoader = StatesLanguageConverter.class.getClassLoader();
    private StatesLanguageConfig config = new StatesLanguageConfig();
    private final List<Smithy2StatesLanguageExtension> extensions = new ArrayList<>();

    private StatesLanguageConverter() {
    }

    public static StatesLanguageConverter create() {
        return new StatesLanguageConverter();
    }

    public StatesLanguageConfig getConfig() {
        return config;
    }

    public StatesLanguageConverter config(StatesLanguageConfig config) {
        this.config = config;
        return this;
    }

    public StatesLanguageConverter classLoader(ClassLoader classLoader) {
        this.classLoader = classLoader;
        return this;
    }

    public Map<ShapeId, ObjectNode> convertToNodes(Model model) {
        ServiceLoader.load(Smithy2StatesLanguageExtension.class, classLoader).forEach(extensions::add);
        StateMachineIndex stateMachineIndex = StateMachineIndex.of(model);
        Map<ShapeId, ObjectNode> nodes = new LinkedHashMap<>();
        // State Machines
        Set<Map.Entry<ShapeId, Map<String, Trait>>> stateMachineSet =
            stateMachineIndex.getStateMachineStates().entrySet();
        for (Map.Entry<ShapeId, Map<String, Trait>> stateMachineEntry : stateMachineSet) {
            // State Machine
            Shape stateMachineShape = model.expectShape(stateMachineEntry.getKey());
            StateMachineTrait stateMachineTrait = stateMachineShape.expectTrait(StateMachineTrait.class);
            Map<String, Trait> stateMachineStates = stateMachineEntry.getValue();
            Context context = new Context(model, config, extensions, stateMachineTrait, stateMachineStates);
            ObjectNode stateMachineObjectNode = stateMachineTrait.toNode().expectObjectNode();
            stateMachineObjectNode = applyStateMachineMappers(stateMachineObjectNode, context);
            nodes.put(stateMachineEntry.getKey(), stateMachineObjectNode);
        }
        return nodes;
    }

    public static ObjectNode applyStateMachineMappers(
        ObjectNode stateMachineObjectNode,
        Context context
    ) {
        for (Smithy2StatesLanguageExtension extension : context.getExtensions()) {
            for (StateMachineMapper mapper : extension.getStateMachineMappers()) {
                stateMachineObjectNode = mapper.updateNode(
                    context,
                    context.getStateMachineTrait(),
                    stateMachineObjectNode);
            }
        }
        return stateMachineObjectNode;
    }

    public static ObjectNode applyStateMappers(
        ObjectNode stateMachineStatesObjectNode,
        Context context
    ) {
        for (Map.Entry<String, Trait> stateEntry : context.getStateMachineStates().entrySet()) {
            // State
            ObjectNode stateObjectNode = stateEntry.getValue().toNode().expectObjectNode();
            for (Smithy2StatesLanguageExtension extension : context.getExtensions()) {
                for (StateMapper mapper : extension.getStateMappers()) {
                    stateObjectNode = mapper.updateNode(
                        context,
                        stateEntry.getValue(),
                        stateObjectNode);
                }
            }
            stateMachineStatesObjectNode = stateMachineStatesObjectNode
                .withMember(stateEntry.getKey(), stateObjectNode);
        }
        return stateMachineStatesObjectNode;
    }
}
