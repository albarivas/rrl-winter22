@isTest
private class FunctionTest {
    @isTest
    static void testSyncFunctionCall() {
        // Set mock class to respond to function invocations
        Test.setMock( functions.FunctionInvokeMock.class, new FunctionsInvokeMockInner());
        functions.Function mockedFunction = functions.Function.get('example.function');

        Test.startTest();
        // Synchronous function call
        functions.FunctionInvocation invokeResult = mockedFunction.invoke('{}');
        Test.stopTest();

        // Verify that the received response contains expected mock values
        System.assertEquals(functions.FunctionInvocationStatus.SUCCESS, invokeResult.getStatus());
        System.assertEquals('mockResponse', invokeResult.getResponse());
        System.assertEquals('000000000000000', invokeResult.getInvocationId());
    }

    @isTest
    static void testAsyncFunctionCallError() {
        // Set mock class to respond to function invocations
        Test.setMock( functions.FunctionInvokeMock.class, new FunctionsInvokeMockInner());
        functions.Function mockedFunction = functions.Function.get('example.function-error');

        Test.startTest();
        //Asynchronous function invocation with callback
        mockedFunction.invoke('{}', new SampleFunctionCallback());
        Test.stopTest();

        // Verify Chatter post has been created
        FeedItem post = [SELECT Id FROM FeedItem ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals('Error while processing Function', post.Subject);
        System.assertEquals('Invocation ID: 000000000000000 \n Error: Function Error!', post.Body);
    }

    public class FunctionsInvokeMockInner implements functions.FunctionInvokeMock {
        String invocationId = '000000000000000';
        public functions.FunctionInvocation respond(String functionName, String payload) {
            if(functionName == 'example.function-error') {
                return functions.MockFunctionInvocationFactory.createErrorResponse(
                    invocationId, // invocationId
                    functions.FunctionErrorType.FUNCTION_EXCEPTION,
                    'Function Error!');
            }

            return functions.MockFunctionInvocationFactory.createSuccessResponse(invocationId, 'success!');
        }
    }
}