public with sharing class SampleFunctionCall {
    public static void callFunctionSynchronously() {
        // Call Function Synchronously
        functions.Function myFunction = functions.Function.get('winter22_examples.myfunction');
        functions.FunctionInvocation invokeResult = myFunction.invoke('{}');

        // Post to Chatter if error
        postToChatter(invokeResult);
    }

    public static void callFunctionAsynchronously() {
        // Call Function Asynchronously
        functions.Function myFunction = functions.Function.get('winter22_examples.myfunction');
        myFunction.invoke('{}', new SampleFunctionCallback());
    }

    private static void postToChatter(functions.FunctionInvocation invokeResult) {
        FeedItem post = new FeedItem();
        post.ParentId = UserInfo.getUserId();
        if (invokeResult.getStatus() == functions.FunctionInvocationStatus.ERROR) {
            post.Title = 'Error while processing Function';
            post.Body = 'Error: ' + invokeResult.getError().getMessage();
        } else {
            post.Title = 'Function executed successfully';
            post.Body = 'Invocation ID: ' + invokeResult.getInvocationId();
        }

        insert post;
    }

    public with sharing class SampleFunctionCallback implements functions.FunctionCallback {
        public void handleResponse(functions.FunctionInvocation invokeResult) { 
            postToChatter(invokeResult);
        }
    }
}