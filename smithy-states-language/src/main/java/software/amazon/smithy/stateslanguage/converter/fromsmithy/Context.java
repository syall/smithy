/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import java.util.List;
import java.util.Map;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.traits.Trait;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageConfig;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;

public final class Context {

    private final Model model;
    private final StatesLanguageConfig config;
    private final List<Smithy2StatesLanguageExtension> extensions;
    private final StateMachineTrait stateMachineTrait;
    private final Map<String, Trait> stateMachineStates;

    Context(
            Model model,
            StatesLanguageConfig config,
            List<Smithy2StatesLanguageExtension> extensions,
            StateMachineTrait stateMachineTrait,
            Map<String, Trait> stateMachineStates
    ) {
        this.model = model;
        this.config = config;
        this.extensions = extensions;
        this.stateMachineTrait = stateMachineTrait;
        this.stateMachineStates = stateMachineStates;
    }

    public Model getModel() {
        return model;
    }

    public StatesLanguageConfig getConfig() {
        return config;
    }

    public List<Smithy2StatesLanguageExtension> getExtensions() {
        return extensions;
    }

    public StateMachineTrait getStateMachineTrait() {
        return stateMachineTrait;
    }

    public Map<String, Trait> getStateMachineStates() {
        return stateMachineStates;
    }
}
