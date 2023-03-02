/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
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
import software.amazon.smithy.utils.IoUtils;

public class StatesLanguageConverterTest {
    @ParameterizedTest
    @MethodSource("getStatesLanguageConverterFiles")
    public void convertsStateMachinesToStatesLanguage(String modelFile) {
        Model model = Model.assembler()
                .addImport(modelFile)
                .addImport(getAthenaModel())
                .addImport(getSnsModel())
                .discoverModels()
                .assemble()
                .unwrap();
        Map<ShapeId, ObjectNode> result = StatesLanguageConverter
                .create()
                .convertToNodes(model);
        assertEquals(true, result.size() >= 1);
        ObjectNode actualNode = getActualNode(result, modelFile);
        assertNotNull(actualNode);
        Node expectedNode = getExpectedNode(modelFile);
        showDiffsOnInequality(actualNode, expectedNode, modelFile);
        assertEquals(expectedNode, actualNode);
    }

    public static List<String> getStatesLanguageConverterFiles() {
        try {
            return Files
                    .walk(Paths.get(StatesLanguageConverter.class.getResource("StatesLanguageConverter").toURI()))
                    .filter(Files::isRegularFile)
                    .filter(file -> file.toString().endsWith(".smithy"))
                    .map(Object::toString)
                    .collect(Collectors.toList());
        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    private static ObjectNode getActualNode(Map<ShapeId, ObjectNode> result, String modelFile) {
        try {
            ShapeId outputStateMachine = ShapeId.from(Node.parse(IoUtils.readUtf8File(
                    modelFile.replace(".smithy", ".outputStateMachine.json"))).expectStringNode().getValue());
            return result.get(outputStateMachine);
        } catch (Exception e) {
            return result.get(result.keySet().iterator().next());
        }
    }

    private static Node getExpectedNode(String modelFile) {
        return Node.parse(IoUtils.readUtf8File(modelFile.replace(".smithy", ".asl.json")));
    }

    private static void showDiffsOnInequality(Node actualNode, Node expectedNode, String modelFile) {
        try {
            Node.assertEquals(actualNode, expectedNode);
        } catch (Exception e) {
            System.err.println(modelFile);
            for (String diff : Node.diff(actualNode, expectedNode)) {
                System.err.println(diff);
            }
            System.err.println(Node.prettyPrintJson(actualNode));
        }
    }

    private static URL getAthenaModel() {
        return StatesLanguageConverter.class.getResource("StatesLanguageConverter/aws/athena.model.json");
    }

    private static URL getSnsModel() {
        return StatesLanguageConverter.class.getResource("StatesLanguageConverter/aws/sns.model.json");
    }
}
