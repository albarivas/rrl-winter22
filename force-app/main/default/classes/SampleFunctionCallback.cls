public with sharing class SampleFunctionCallback implements functions.FunctionCallback {
    public void handleResponse(functions.FunctionInvocation invokeResult) {
        
        if (invokeResult.getStatus() == functions.FunctionInvocationStatus.ERROR) {
            FeedItem post = new FeedItem();
            post.Subject = 'Error while processing Function';
            post.Body = 'Invocation ID: ' + invokeResult.getInvocationId() + '\n Error: ' + invokeResult.getError();

            try {
                insert post;
            } catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }
}