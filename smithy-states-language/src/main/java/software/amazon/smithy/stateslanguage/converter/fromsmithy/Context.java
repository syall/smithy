/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import java.util.List;
import java.util.Map;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.knowledge.StateMachineIndex;

public final class Context {

    private final Model model;
    private final List<Smithy2StatesLanguageExtension> extensions;
    private final Map<String, Trait> stateMachineStates;
    private final StateMachineIndex stateMachineIndex;

    public Context(
            Model model,
            List<Smithy2StatesLanguageExtension> extensions,
            Map<String, Trait> stateMachineStates,
            StateMachineIndex stateMachineIndex
    ) {
        this.model = model;
        this.extensions = extensions;
        this.stateMachineStates = stateMachineStates;
        this.stateMachineIndex = stateMachineIndex;
    }

    public Model getModel() {
        return model;
    }

    public List<Smithy2StatesLanguageExtension> getExtensions() {
        return extensions;
    }

    public Map<String, Trait> getStateMachineStates() {
        return stateMachineStates;
    }

    public StateMachineIndex getStateMachineIndex() {
        return stateMachineIndex;
    }
}
