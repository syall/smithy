/*
 * Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers;

import java.util.List;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.Smithy2StatesLanguageExtension;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMachineMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.StateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state.ChoiceStateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state.PassStateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state.TaskStateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.state.WaitStateMapper;
import software.amazon.smithy.stateslanguage.converter.fromsmithy.mappers.statemachine.ApplyStateMappersMapper;
import software.amazon.smithy.utils.ListUtils;

public final class CoreExtension implements Smithy2StatesLanguageExtension {
    @Override
    public List<StateMachineMapper> getStateMachineMappers() {
        return ListUtils.of(
            new UppercaseMembersMapper(),
            new ApplyStateMappersMapper()
        );
    }

    @Override
    public List<StateMapper> getStateMappers() {
        return ListUtils.of(
            new UppercaseMembersMapper(),
            new ChoiceStateMapper(),
            new TaskStateMapper(),
            new WaitStateMapper(),
            new PassStateMapper()
        );
    }
}
