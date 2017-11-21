public with sharing class brUserServiceSelector {	
	
    public static List<NetworkMember> getUserMembers(Id communityId, Integer limitSql) {
    	
    	List<NetworkMember> userMembers = [SELECT MemberId, Member.Name , ReputationPoints 
    								 FROM NetworkMember 
    								 WHERE 
    								 	NetworkId = :communityId   								 	
    								 ORDER BY ReputationPoints DESC 
    								 limit :limitSql];
    	return userMembers;
    	
    }
    
    public static List<NetworkMember> getLogUserMember(Id communityId) {    
    		
    	List<NetworkMember> userMembers = [SELECT MemberId, Member.Name , ReputationPoints 
    								 FROM NetworkMember 
    								 WHERE 
    								 	NetworkId = :communityId AND
    								 	MemberId = :UserInfo.getUserId()
    								 limit 1];
    								 
    	if (userMembers != null) { 		
    		return userMembers;   		
    	} else {
    		return null;
    	}				
    				     	
    }    
    
    public static List<User> getUserMemberPhotoUrl(Set<Id> memberIds) {
    	
    	List<User> userMembers = [SELECT Id, FullPhotoUrl 
    								 FROM User 
    								 WHERE 
    								 	Id IN :memberIds];
    	return userMembers;
    	
    }   
    
    public static List<ReputationLevel> getUserReputationLevels(Id communityId) {
    	
    	List<ReputationLevel> reputationLevels = [SELECT id, Label,LevelNumber,Threshold, ParentId 
    									  FROM ReputationLevel 
    									  WHERE 
    									  	ParentId = :communityId
    									  ORDER BY Threshold ASC];
    	return reputationLevels;
    	
    }     
    
}