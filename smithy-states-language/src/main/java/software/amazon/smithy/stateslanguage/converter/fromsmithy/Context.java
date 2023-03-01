/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import software.amazon.smithy.model.Model;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageConfig;

public final class Context {

    private final Model model;
    private final StatesLanguageConfig config;

    Context(
            Model model,
            StatesLanguageConfig config
    ) {
        this.model = model;
        this.config = config;
    }

    public Model getModel() {
        return model;
    }

    public StatesLanguageConfig getConfig() {
        return config;
    }

}
