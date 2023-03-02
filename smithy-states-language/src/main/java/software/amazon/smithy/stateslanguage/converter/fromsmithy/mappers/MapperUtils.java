/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers;

import java.util.Optional;
import software.amazon.smithy.model.node.Node;
import software.amazon.smithy.model.node.ObjectNode;
import software.amazon.smithy.model.node.StringNode;

public final class MapperUtils {
    private MapperUtils() {
    }

    public static ObjectNode withStateType(String stateType, ObjectNode objectNode) {
        return objectNode.withMember("Type", stateType);
    }

    public static ObjectNode uppercaseFirstLetterMembers(ObjectNode objectNode) {
        for (StringNode memberName : objectNode.getMembers().keySet()) {
            objectNode = MapperUtils.uppercaseFirstLetterMember(memberName.getValue(), objectNode);
        }
        return objectNode;
    }

    public static ObjectNode uppercaseFirstLetterMember(String memberName, ObjectNode objectNode) {
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
