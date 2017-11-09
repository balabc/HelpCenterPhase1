public with sharing class brChatterGroupServiceSelector {
    public static List<SObject> getChatterGroup(Set<Id> ids, Integer limitSql) {
    	List<SObject> groupList = [SELECT id, Name FROM CollaborationGroup WHERE id IN :ids limit :limitSql];
    	return groupList;
    }
    public static Id getListId() {
    	List<ListView> listViews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'CollaborationGroup' and Name = 'Active Groups'];
    	if(listViews.size() > 0) {
    		return listViews[0].id;
    	} else {
    		return null;
    	}
    }
    
}