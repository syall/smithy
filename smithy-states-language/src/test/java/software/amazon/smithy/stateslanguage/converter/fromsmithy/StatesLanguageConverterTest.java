/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.util.Map;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageConfig;

public class StatesLanguageConverterTest {

    private static Model testService;

    @BeforeAll
    private static void setup() {
        testService = Model.assembler()
                .addImport(StatesLanguageConverter.class.getResource("test-states-language.smithy"))
                .discoverModels()
                .assemble()
                .unwrap();
    }

    @Test
    public void convertsStateMachinesToStatesLanguage() {
        StatesLanguageConfig config = new StatesLanguageConfig();
        Map<ShapeId, ObjectNode> result = StatesLanguageConverter.create()
                .config(config)
                .convertToNodes(testService);
        assertEquals(1, result.size());
        ObjectNode node = result.get(ShapeId.from("codebuild.example#CodeBuildStateMachine"));
        assertNotNull(node);
        System.out.println(Node.prettyPrintJson(node));
    }
}
