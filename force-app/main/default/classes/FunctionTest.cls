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
        List<FeedItem> posts = [SELECT Title, Body FROM FeedItem ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals(1, posts.size());
        FeedItem post = posts[0];
        System.assertEquals('Function executed successfully', post.Title);
        System.assertEquals('Invocation ID: 000000000000000', post.Body);
    }

    @isTest
    static void testAsyncFunctionCallError() {
        // Set mock class to respond to function invocations
        FunctionsInvokeMockInner mock = new FunctionsInvokeMockInner();
        mock.throwError = true;
        Test.setMock(functions.FunctionInvokeMock.class, mock);

        //Asynchronous function invocation with callback
        Test.startTest();
        SampleFunctionCall.callFunctionAsynchronously();
        Test.stopTest();

        // Verify Chatter post has been created
        List<FeedItem> posts = [SELECT Title, Body FROM FeedItem ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals(1, posts.size());
        FeedItem post = posts[0];
        System.assertEquals('Error while processing Function', post.Title);
        System.assertEquals('Error: Function returned an error!', post.Body);
    }

    public class FunctionsInvokeMockInner implements functions.FunctionInvokeMock {
        public Boolean throwError = false;
        private String invocationId = '000000000000000';

        public functions.FunctionInvocation respond(String functionName, String payload) {
            if(throwError) {
                return functions.MockFunctionInvocationFactory.createErrorResponse(
                    invocationId,
                    functions.FunctionErrorType.FUNCTION_EXCEPTION,
                    'Function returned an error!');
            }
    
            return functions.MockFunctionInvocationFactory.createSuccessResponse(invocationId, 'Success!');
       }
    }
}