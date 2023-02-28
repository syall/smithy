$version: "2.0"

namespace example.hello.world

/// The operation of a state machine is specified by states, which are
/// represented by JSON objects, fields in the top-level "States" object. In
/// this example, there is one state named "Hello World".
@externalDocumentation(
    "Example: Hello World": "https://states-language.net/spec.html#example"
)
@smithy.stateslanguage#stateMachine(
    comment: "A simple minimal example of the States language"
    startAt: "Hello World"
    states: {
        "Hello World": HelloWorldTask
    }
)
structure ExampleHelloWorld {}

/// In this example, the machine contains a single state named "Hello World".
/// Because "Hello World" is a Task State, the interpreter tries to execute it.
/// Examining the value of the "Resource" field shows that it points to a
/// Lambda function, so the interpreter attempts to invoke that function.
/// Assuming the Lambda function executes successfully, the machine will
/// terminate successfully.
@smithy.stateslanguage#state
structure HelloWorldTask {
    type: String = "Task"
    resouce: String = "arn:aws:lambda:us-east-1:123456789012:function:HelloWorld"
    end: Boolean = true
}
