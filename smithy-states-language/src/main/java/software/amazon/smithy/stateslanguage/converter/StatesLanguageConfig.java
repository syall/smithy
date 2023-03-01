/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter;

import java.util.Map;
import software.amazon.smithy.jsonschema.JsonSchemaConfig;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.NodeMapper;
import software.amazon.smithy.model.node.ObjectNode;

public final class StatesLanguageConfig extends JsonSchemaConfig {

    public StatesLanguageConfig() {
        super();
    }

    public static StatesLanguageConfig fromNode(Node settings) {
        NodeMapper mapper = new NodeMapper();

        mapper.setWhenMissingSetter(NodeMapper.WhenMissing.INGORE);

        ObjectNode node = settings.expectObjectNode();
        StatesLanguageConfig config = new StatesLanguageConfig();
        mapper.deserializeInto(node, config);

        // Add all properties to "extensions" to make them accessible
        // in plugins.
        for (Map.Entry<String, Node> entry : node.getStringMap().entrySet()) {
            config.putExtension(entry.getKey(), entry.getValue());
        }

        return config;
    }
}
