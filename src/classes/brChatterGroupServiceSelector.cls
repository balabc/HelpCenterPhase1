public with sharing class brChatterGroupServiceSelector {
    public static List<SObject> getChatterGroup(List<Id> ids) {
    	List<SObject> groupList = new List<SObject>();
    	if(ids.size() == 1) {
    		SObject groupS1 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[0]]; 
    		groupList.add(groupS1);
    	}
    	if(ids.size() == 2) {
    		SObject groupS1 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[0]]; 
    		groupList.add(groupS1);
    		SObject groupS2 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[1]]; 
    		groupList.add(groupS2);    		
    	}
    	if(ids.size() == 3) {
    		SObject groupS1 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[0]]; 
    		groupList.add(groupS1);
    		SObject groupS2 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[1]]; 
    		groupList.add(groupS2);
    		SObject groupS3 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[2]]; 
    		groupList.add(groupS3);      		
    	}
    	if(ids.size() == 4) {
    		SObject groupS1 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[0]]; 
    		groupList.add(groupS1);
    		SObject groupS2 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[1]]; 
    		groupList.add(groupS2);
    		SObject groupS3 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[2]]; 
    		groupList.add(groupS3);      		
    		SObject groupS4 = [SELECT id, Name FROM CollaborationGroup WHERE id = :ids[3]]; 
    		groupList.add(groupS4);
    	}    	    	   	 	
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