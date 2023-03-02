/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;

import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageConfig;
import software.amazon.smithy.utils.IoUtils;

public class StatesLanguageConverterTest {
    @ParameterizedTest
    @MethodSource("getStatesLanguageConverterFiles")
    public void convertsStateMachinesToStatesLanguage(String modelFile) {
        Model model = Model.assembler()
                .addImport(modelFile)
                .discoverModels()
                .assemble()
                .unwrap();
        StatesLanguageConfig config = new StatesLanguageConfig();
        Map<ShapeId, ObjectNode> result = StatesLanguageConverter.create()
                .config(config)
                .convertToNodes(model);
        assertEquals(1, result.size());
        ObjectNode actualNode = result.get(result.keySet().iterator().next());
        Node expectedNode = Node.parse(IoUtils.readUtf8File(modelFile.replace(".smithy", ".asl.json")));
        Node.assertEquals(actualNode, expectedNode);
    }

    public static List<String> getStatesLanguageConverterFiles() {
        try {
            return Files.walk(Paths.get(StatesLanguageConverter.class.getResource("StatesLanguageConverter").toURI()))
                    .filter(Files::isRegularFile)
                    .filter(file -> file.toString().endsWith(".smithy"))
                    .map(Object::toString)
                    .collect(Collectors.toList());
        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }
}
