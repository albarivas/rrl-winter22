public with sharing class SampleInvocableAction {
    @InvocableMethod(label='Construct Sentence')
    public static List<String> tellMeSomething(List<String> mascot) {
        return new List<String>{mascot[0] + ' thinks the new Developer Website is amazing!!'};
    }
}
