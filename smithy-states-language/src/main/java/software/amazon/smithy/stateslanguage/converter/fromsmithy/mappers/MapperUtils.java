/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers;

import java.util.Optional;
import software.amazon.smithy.model.node.ArrayNode;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.NullNode;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.node.StringNode;
import software.amazon.smithy.stateslanguage.converter.StatesLanguageException;

public final class MapperUtils {
    private MapperUtils() {
    }

    public static ObjectNode withStateType(String stateType, ObjectNode objectNode) {
        return objectNode.withMember("Type", stateType);
    }

    public static ObjectNode withNextOrEnd(ObjectNode objectNode) {
        if (!objectNode.containsMember("NextOrEnd")) {
            throw new StatesLanguageException(
                    "Expected `nextOrEnd` on in node: `" + Node.prettyPrintJson(objectNode) + "`");
        }
        ObjectNode nextOrEndNode = objectNode.expectObjectMember("NextOrEnd");
        objectNode = objectNode.withoutMember("NextOrEnd");
        if (nextOrEndNode.containsMember("next")) {
            return objectNode.withMember("Next", nextOrEndNode.expectStringMember("next"));
        } else if (nextOrEndNode.containsMember("end")) {
            return objectNode.withMember("End", nextOrEndNode.expectBooleanMember("end"));
        }
        throw new StatesLanguageException(
                "Expected `next` or `end` on in `nextOrEnd`: `" + Node.prettyPrintJson(nextOrEndNode) + "`");
    }

    public static ObjectNode withMemberOrStatePath(String memberName, ObjectNode objectNode) {
        if (!objectNode.containsMember(memberName)) {
            return objectNode;
        }
        ObjectNode memberNode = objectNode.expectObjectMember(memberName);
        objectNode = objectNode.withoutMember(memberName);
        if (memberNode.containsMember("value")) {
            return objectNode.withMember(memberName, memberNode.expectMember("value"));
        } else if (memberNode.containsMember("path")) {
            return objectNode.withMember(memberName + "Path", memberNode.expectMember("path"));
        }
        throw new StatesLanguageException(
                "Expected `value` or `path` on in `" + memberName + "`: `"
                        + Node.prettyPrintJson(memberNode) + "`");
    }

    public static ObjectNode withRetry(ObjectNode objectNode) {
        if (!objectNode.containsMember("Retry")) {
            return objectNode;
        }
        return objectNode.withMember("Retry",
                withUppercaseFirstLetterObjectMembers(objectNode.expectArrayMember("Retry")));
    }

    public static ObjectNode withCatch(ObjectNode objectNode) {
        if (!objectNode.containsMember("Catch")) {
            return objectNode;
        }
        objectNode = objectNode.withMember("Catch",
                withUppercaseFirstLetterObjectMembers(objectNode.expectArrayMember("Catch")));
        ArrayNode result = ArrayNode.arrayNode();
        for (Node catchNode : objectNode.expectArrayMember("Catch").getElements()) {
            result = result.withValue(withResultPath(catchNode.expectObjectNode()));
        }
        return objectNode.withMember("Catch", result);
    }

    public static ObjectNode withInputPathOutputPath(ObjectNode objectNode) {
        if (objectNode.containsMember("InputPath")) {
            ObjectNode memberNode = objectNode.expectObjectMember("InputPath");
            if (memberNode.containsMember("path")) {
                objectNode = objectNode.withMember("InputPath", memberNode.expectStringMember("path"));
            } else if (memberNode.containsMember("null")) {
                objectNode = objectNode.withMember("InputPath",
                        new NullNode(memberNode.expectBooleanMember("null").getSourceLocation()));
            }
        }
        if (objectNode.containsMember("OutputPath")) {
            ObjectNode memberNode = objectNode.expectObjectMember("OutputPath");
            if (memberNode.containsMember("path")) {
                objectNode = objectNode.withMember("OutputPath", memberNode.expectStringMember("path"));
            } else if (memberNode.containsMember("null")) {
                objectNode = objectNode.withMember("OutputPath",
                        new NullNode(memberNode.expectBooleanMember("null").getSourceLocation()));
            }
        }
        return objectNode;
    }

    public static ObjectNode withResultPath(ObjectNode objectNode) {
        if (objectNode.containsMember("ResultPath")) {
            ObjectNode memberNode = objectNode.expectObjectMember("ResultPath");
            if (memberNode.containsMember("path")) {
                objectNode = objectNode.withMember("ResultPath", memberNode.expectStringMember("path"));
            } else if (memberNode.containsMember("null")) {
                objectNode = objectNode.withMember("ResultPath",
                        new NullNode(memberNode.expectBooleanMember("null").getSourceLocation()));
            }
        }
        return objectNode;
    }

    private static ArrayNode withUppercaseFirstLetterObjectMembers(ArrayNode arrayNode) {
        ArrayNode result = ArrayNode.arrayNode();
        for (Node node : arrayNode.getElements()) {
            result = result.withValue(withUppercaseFirstLetterMembers(node.expectObjectNode()));
        }
        return result;
    }

    public static ObjectNode withUppercaseFirstLetterMembers(ObjectNode objectNode) {
        for (StringNode memberName : objectNode.getMembers().keySet()) {
            objectNode = MapperUtils.uppercaseFirstLetterMember(memberName.getValue(), objectNode);
        }
        return objectNode;
    }

    private static ObjectNode uppercaseFirstLetterMember(String memberName, ObjectNode objectNode) {
        Optional<Node> targetNode = objectNode.getMember(memberName);
        if (targetNode.isPresent()) {
            String newMemberName = uppercaseFirstLetter(memberName);
            objectNode = objectNode.withMember(newMemberName, targetNode.get());
            objectNode = objectNode.withoutMember(memberName);
        }
        return objectNode;
    }

    private static String uppercaseFirstLetter(String str) {
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }
}
