public with sharing class SampleFunctionCall {
    public static void callFunctionSynchronously() {
        // Call Function Synchronously
        functions.Function myFunction = functions.Function.get('example.successfunction');
        functions.FunctionInvocation invokeResult = myFunction.invoke('{}');

        // Post to Chatter if error
        postToChatter(invokeResult);
    }

    public static void callFunctionAsynchronously() {
        // Call Function Asynchronously
        functions.Function myFunction = functions.Function.get('example.errorfunction');
        myFunction.invoke('{}', new SampleFunctionCallback());

    }

    private static void postToChatter(functions.FunctionInvocation invokeResult) {
        FeedItem post = new FeedItem();
        if (invokeResult.getStatus() == functions.FunctionInvocationStatus.ERROR) {
            post.Subject = 'Error while processing Function';
            post.Body = 'Invocation ID: ' + invokeResult.getInvocationId() + '\n Error: ' + invokeResult.getError();
        } else {
            post.Subject = 'Function executed successfully';
            post.Body = 'Invocation ID: ' + invokeResult.getInvocationId();
        }

        try {
            insert post;
        } catch (Exception e) {
            System.debug('Problem posting to Chatter: ' + e.getMessage());
        }
    }

    public with sharing class SampleFunctionCallback implements functions.FunctionCallback {
        public void handleResponse(functions.FunctionInvocation invokeResult) { 
            postToChatter(invokeResult);
        }
    }
}
