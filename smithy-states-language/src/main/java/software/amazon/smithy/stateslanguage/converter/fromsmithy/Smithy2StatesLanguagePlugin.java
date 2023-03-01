/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import java.util.Locale;
import java.util.Map;
import software.amazon.smithy.build.FileManifest;
import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.build.SmithyBuildPlugin;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageConfig;

public final class Smithy2StatesLanguagePlugin implements SmithyBuildPlugin {
    @Override
    public String getName() {
        return "stateslanguage";
    }

    @Override
    public void execute(PluginContext context) {
        StatesLanguageConverter converter = StatesLanguageConverter.create();
        context.getPluginClassLoader().ifPresent(converter::classLoader);
        StatesLanguageConfig config = StatesLanguageConfig.fromNode(context.getSettings());
        converter.config(config);

        Map<ShapeId, ObjectNode> nodes = converter.convertToNodes(context.getModel());
        FileManifest fileManifest = context.getFileManifest();
        nodes.entrySet().forEach(entry -> {
            String fileName = getFileNameFromStateMachine(entry.getKey());
            fileManifest.writeJson(fileName, entry.getValue());
        });
    }

    static String getFileNameFromStateMachine(ShapeId shapeId) {
        return shapeId.toString()
            .toLowerCase(Locale.US)
            .replace(".", "-")
            .replace("#", "-")
            + ".asl.json";
    }
}
