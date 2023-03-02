/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.traits.validators;

import java.util.ArrayList;
import java.util.List;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.shapes.Shape;
import software.amazon.smithy.model.validation.AbstractValidator;
import software.amazon.smithy.model.validation.ValidationEvent;
import software.amazon.smithy.stateslanguage.traits.StateMachineTrait;

public final class StateMachineNamesValidator extends AbstractValidator {
    @Override
    public List<ValidationEvent> validate(Model model) {
        List<ValidationEvent> events = new ArrayList<>();
        for (Shape shape : model.getShapesWithTrait(StateMachineTrait.class)) {
            StateMachineTrait trait = shape.expectTrait(StateMachineTrait.class);
            // If startAt is not in states
            if (trait.getStates().get(trait.getStartAt()) == null) {
                events.add(error(shape, trait, String.format("Member `startAt` of \"%s\" "
                        + "is not available in the `states`", trait.getStartAt())));
            }
        }
        return events;
    }
}
