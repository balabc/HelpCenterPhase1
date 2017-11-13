public with sharing class brUserServiceSelector {	
	
    public static List<SObject> getUserMembers(Id communityId) {
    	List<NetworkMember> userMembers = [SELECT MemberId, Member.Name , ReputationPoints 
    								 FROM NetworkMember 
    								 WHERE 
    								 	NetworkId = :communityId  
    								 ORDER BY ReputationPoints DESC limit 6];
    	return userMembers;
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