public with sharing class SampleInvocableAction {
    @InvocableMethod(label='Construct Sentence')
    public static List<String> tellMeSomething(List<String> mascot) {
        String mascotName = mascot == null || mascot.isEmpty() || String.isBlank(mascot[0]) ? 'Appy' : mascot[0];
        return new List<String>{mascotName + ' thinks the new Developer Website is amazing!!'};
    }
}