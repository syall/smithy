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
import software.amazon.smithy.utils.IoUtils;

public class StatesLanguageConverterTest {
    @ParameterizedTest
    @MethodSource("getSingleStatesLanguageConverterFiles")
    public void convertsSingleStateMachinesToStatesLanguage(String modelFile) {
        Model model = Model.assembler()
                .addImport(modelFile)
                .discoverModels()
                .assemble()
                .unwrap();
        Map<ShapeId, ObjectNode> result = StatesLanguageConverter.create()
                .convertToNodes(model);
        assertEquals(1, result.size());
        ObjectNode actualNode = result.get(result.keySet().iterator().next());
        Node expectedNode = Node.parse(IoUtils.readUtf8File(modelFile.replace(".smithy", ".asl.json")));
        try {
            Node.assertEquals(actualNode, expectedNode);
        } catch (Exception e) {
            System.err.println(modelFile);
            for (String diff : Node.diff(actualNode, expectedNode)) {
                System.err.println(diff);
            }
            System.err.println(Node.prettyPrintJson(actualNode));
        }
        assertEquals(expectedNode, actualNode);
    }

    public static List<String> getSingleStatesLanguageConverterFiles() {
        try {
            return Files.walk(Paths.get(StatesLanguageConverter.class.getResource("StatesLanguageConverter/single").toURI()))
                    .filter(Files::isRegularFile)
                    .filter(file -> file.toString().endsWith(".smithy"))
                    .map(Object::toString)
                    .collect(Collectors.toList());
        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    @ParameterizedTest
    @MethodSource("getMultipleStatesLanguageConverterFiles")
    public void convertsMultipleStateMachinesToStatesLanguage(String modelFile) {
        Model model = Model.assembler()
                .addImport(modelFile)
                .discoverModels()
                .assemble()
                .unwrap();
        Map<ShapeId, ObjectNode> result = StatesLanguageConverter.create()
                .convertToNodes(model);
        assertEquals(true, result.size() > 1);
        ShapeId outputStateMachine = ShapeId.from(Node.parse(IoUtils.readUtf8File(
                modelFile.replace(".smithy", ".outputStateMachine.json"))).expectStringNode().getValue());
        ObjectNode actualNode = result.get(outputStateMachine);
        Node expectedNode = Node.parse(IoUtils.readUtf8File(
                modelFile.replace(".smithy", ".asl.json")));
        try {
            Node.assertEquals(actualNode, expectedNode);
        } catch (Exception e) {
            System.err.println(modelFile);
            for (String diff : Node.diff(actualNode, expectedNode)) {
                System.err.println(diff);
            }
            System.err.println(Node.prettyPrintJson(actualNode));
        }
        assertEquals(expectedNode, actualNode);
    }

    public static List<String> getMultipleStatesLanguageConverterFiles() {
        try {
            return Files.walk(Paths.get(StatesLanguageConverter.class.getResource("StatesLanguageConverter/multiple").toURI()))
                    .filter(Files::isRegularFile)
                    .filter(file -> file.toString().endsWith(".smithy"))
                    .map(Object::toString)
                    .collect(Collectors.toList());
        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    @ParameterizedTest
    @MethodSource("getExampleStatesLanguageConverterFiles")
    public void convertsExampleStateMachinesToStatesLanguage(String modelFile) {
        Model model = Model.assembler()
                .addImport(modelFile)
                .discoverModels()
                .assemble()
                .unwrap();
        Map<ShapeId, ObjectNode> result = StatesLanguageConverter.create()
                .convertToNodes(model);
        ObjectNode actualNode = result.get(result.keySet().iterator().next());
        Node expectedNode = Node.parse(IoUtils.readUtf8File(
                modelFile.replace(".smithy", ".asl.json")));
        try {
            Node.assertEquals(actualNode, expectedNode);
        } catch (Exception e) {
            System.err.println(modelFile);
            for (String diff : Node.diff(actualNode, expectedNode)) {
                System.err.println(diff);
            }
            System.err.println(Node.prettyPrintJson(actualNode));
        }
        assertEquals(expectedNode, actualNode);
    }

    public static List<String> getExampleStatesLanguageConverterFiles() {
        try {
            return Files.walk(Paths.get(StatesLanguageConverter.class.getResource("StatesLanguageConverter/example").toURI()))
                    .filter(Files::isRegularFile)
                    .filter(file -> file.toString().endsWith(".smithy"))
                    .map(Object::toString)
                    .collect(Collectors.toList());
        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }
}
