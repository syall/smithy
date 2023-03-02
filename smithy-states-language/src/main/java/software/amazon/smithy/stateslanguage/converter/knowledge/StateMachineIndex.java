/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.knowledge;

import java.util.HashMap;
import java.util.Map;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.knowledge.KnowledgeIndex;
import software.amazon.smithy.model.shapes.Shape;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageException;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;
import software.amazon.smithy.stateslanguage.traits.StateTrait;

public final class StateMachineIndex implements KnowledgeIndex {

    private final Map<ShapeId, Map<String, Trait>> stateMachineStates = new HashMap<>();

    public StateMachineIndex(Model model) {
        model.getShapesWithTrait(StateMachineTrait.class).forEach(shape -> {
            StateMachineTrait stateMachineTrait = shape.expectTrait(StateMachineTrait.class);
            stateMachineStates.putIfAbsent(shape.getId(), new HashMap<>());
            Map<String, Trait> stateMachineMap = stateMachineStates.get(shape.getId());
            if (stateMachineMap == null) {
                throw new IllegalStateException(
                    "State Machine `" + shape.getId() + "` should be in the State Machine Index");
            }
            stateMachineTrait.getStates().forEach((stateName, shapeId) -> {
                if (stateMachineMap.containsKey(stateName)) {
                    throw new StatesLanguageException(
                        "State `" + stateName + "`is already defined in State Machine `" + shape.getId() + "`");
                }
                Shape stateShape = model.expectShape(shapeId);
                StateTrait stateTrait = stateShape.expectTrait(StateTrait.class);
                ShapeId stateDefinition = stateTrait.getDefinition();
                Trait stateDefinitionTrait = stateShape.getAllTraits().entrySet().stream()
                        .filter(entry -> entry.getKey().equals(stateDefinition))
                        .findFirst()
                        .map(s -> s.getValue())
                        .orElseThrow(() -> new StatesLanguageException(
                            "Could not find associated state definition `"
                            + stateDefinition + "` on state `" + shapeId + "`"));
                stateMachineMap.put(stateName, stateDefinitionTrait);
            });
        });
    }

    public static StateMachineIndex of(Model model) {
        return model.getKnowledge(StateMachineIndex.class, StateMachineIndex::new);
    }

    public Map<ShapeId, Map<String, Trait>> getStateMachineStates() {
        return stateMachineStates;
    }
}
