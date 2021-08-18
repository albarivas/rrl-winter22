@isTest
private class FunctionTest {
    @isTest
    static void testSyncFunctionCall() {
        // Set mock class to respond to function invocations
        Test.setMock(functions.FunctionInvokeMock.class, new FunctionsInvokeMockInner());

        // Synchronous function call
        Test.startTest();
        SampleFunctionCall.callFunctionSynchronously();
        Test.stopTest();

        // Verify success Chatter post has been created
        FeedItem post = [SELECT Id FROM FeedItem ORDER BY CreatedDate DESC LIMIT 1];
        System.assertNotEquals(null, post);
        System.assertEquals('Function executed successfully', post.Subject);
        System.assertEquals('Invocation ID: 000000000000000', post.Body);
    }

    @isTest
    static void testAsyncFunctionCallError() {
        // Set mock class to respond to function invocations
        Test.setMock(functions.FunctionInvokeMock.class, new FunctionsInvokeMockInner());
        functions.Function mockedFunction = functions.Function.get('example.errorfunction');

        //Asynchronous function invocation with callback
        Test.startTest();
        SampleFunctionCall.callFunctionAsynchronously();
        Test.stopTest();

        // Verify Chatter post has been created
        FeedItem post = [SELECT Id FROM FeedItem ORDER BY CreatedDate DESC LIMIT 1];
        System.assertNotEquals(null, post);
        System.assertEquals('Error while processing Function', post.Subject);
        System.assertEquals('Invocation ID: 000000000000000 \n Error: Function returned an error!', post.Body);
    }

    public class FunctionsInvokeMockInner implements functions.FunctionInvokeMock {
        String invocationId = '000000000000000';
        public functions.FunctionInvocation respond(String functionName, String payload) {
            if(functionName == 'example.errorfunction') {
                return functions.MockFunctionInvocationFactory.createErrorResponse(
                    invocationId,
                    functions.FunctionErrorType.FUNCTION_EXCEPTION,
                    'Function returned an error!');
            }
    
            return functions.MockFunctionInvocationFactory.createSuccessResponse(invocationId, 'Success!');
       }
    }
}