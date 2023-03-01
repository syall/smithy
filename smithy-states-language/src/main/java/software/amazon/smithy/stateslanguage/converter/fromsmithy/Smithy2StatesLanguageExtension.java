/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy;

import java.util.List;
import software.amazon.smithy.utils.ListUtils;

public interface Smithy2StatesLanguageExtension {
    default List<StatesLanguageStateMachineMapper> getStatesLanguageStateMachineMappers() {
        return ListUtils.of();
    }

    default List<StatesLanguageStateMapper> getStatesLanguageStateMappers() {
        return ListUtils.of();
    }
}
