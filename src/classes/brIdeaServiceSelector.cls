public with sharing class brIdeaServiceSelector {
    
    public static List<Community> getZoneList(String networkId) {
    	
    	List<Community> zoneList = new List<Community>();
    	zoneList = [SELECT id, NetworkId 
    				FROM Community 
    				WHERE 
    					NetworkId = :networkId];
    	return zoneList;
    	
    }
    
    public static List<Idea> getIdeaList(List<Community> zoneList) {
    	
    	List<Idea> listIdea = new List<Idea>();
    	listIdea = [SELECT id
    				FROM Idea 
    				WHERE 
    					CommunityId IN :zoneList];
    	return listIdea;				
    	
    }
    
    
}