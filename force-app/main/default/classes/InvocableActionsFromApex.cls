public with sharing class InvocableActionsFromApex {

    public static void callStandardInvocableAction(){
        Invocable.Action action = Invocable.Action.createStandardAction('chatterPost');
        action.setInvocationParameter('text', 'I love the new Developer Website!');
        action.setInvocationParameter('type', 'User');
        action.setInvocationParameter('subjectNameOrId', UserInfo.getUserId());

        List<Invocable.Action.Result> results = action.invoke();

        if (results.size() > 0 && results[0].isSuccess()) {
            System.debug('Feed Item Id:' + results[0].getOutputParameters().get('feedItemId'));
        }
    }

    public static void callCustomInvocableAction(){
        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'SampleInvocableAction');
        action.setInvocationParameter('mascot', 'Codey');

        List<Invocable.Action.Result> results = action.invoke();

        if (results.size() > 0 && results[0].isSuccess()) {
            System.debug('Result is: ' + results[0].getOutputParameters().get('output'));
        }
    }

}
