/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package software.amazon.smithy.stateslanguage.converter;

public class StatesLanguageException extends RuntimeException {
    public StatesLanguageException(RuntimeException e) {
        super(e);
    }

    public StatesLanguageException(String message) {
        super(message);
    }

    public StatesLanguageException(String message, Throwable previous) {
        super(message, previous);
    }
}
