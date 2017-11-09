public with sharing class brChatterGroupServiceSelector {
    public static List<SObject> getChatterGroup(Set<Id> ids, Integer limitSql) {
    	List<SObject> groupList = [SELECT id, Name FROM CollaborationGroup WHERE id IN :ids limit :limitSql];
    	return groupList;
    }
}