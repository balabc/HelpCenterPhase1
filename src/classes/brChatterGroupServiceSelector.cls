public with sharing class brChatterGroupServiceSelector {
    public static List<SObject> getChatterGroup(Set<Id> ids) {
    	List<SObject> groupList = [SELECT id, Name FROM CollaborationGroup WHERE id IN :ids];
    	return groupList;
    }
}