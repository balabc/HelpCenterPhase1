public with sharing class brUserService {
	
    public static List<brLeaderboardModel> getUserLeaderboard(Id communityId) {
    	
    	List<brLeaderboardModel> leaderboardModels = new List<brLeaderboardModel>();
    	List<NetworkMember> userMembers = brUserServiceSelector.getUserMembers(communityId);
    	Set<Id> memberIds = new Set<Id>();
    	
    	for (NetworkMember userMember : userMembers) {
    		memberIds.add(userMember.MemberId);
    	}
    	
    	List<User> userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);
    	List<ReputationLevel> userReputationLevels = brUserServiceSelector.getUserReputationLevels(communityId);    	
    	List<UserReputation> userReputationList = new List<UserReputation>();
    	
    	for (Integer i = 0; i < userReputationLevels.size(); i++) {
    		UserReputation obj = new UserReputation();   		
    		if (i != userReputationLevels.size() -1) {
    			obj.label = userReputationLevels[i].Label;
    			obj.minScore = userReputationLevels[i].Threshold;
    			obj.maxScore = userReputationLevels[i+1].Threshold;
    		} else {
    			obj.label = userReputationLevels[i].Label;
    			obj.minScore = userReputationLevels[i].Threshold;  			
    		}
    		userReputationList.add(obj);
    	}
    	
    	for (NetworkMember userMember : userMembers) {
    		brLeaderboardModel lbm = new brLeaderboardModel();
    		lbm.name = userMember.Member.Name;
    		lbm.score = String.valueOf(userMember.ReputationPoints);
    		
    		for (User us : userMembersPhotoUrl) {
    			if (userMember.MemberId == us.id) {
    				lbm.photoUrl = us.FullPhotoUrl;
    				break;
    			}
    		}
    		
    		for (Integer i = 0; i < userReputationList.size(); i++) {
    			if(userMember.ReputationPoints > userReputationList[i].minScore && userMember.ReputationPoints < userReputationList[i].maxScore) {
    				lbm.reputationLevel =  userReputationLevels[i].Label;
    			}
    		}
    		leaderboardModels.add(lbm);
    		
    	}
    	
    	return leaderboardModels;
    	
    }
    
    public class UserReputation {
    	
    	public String label {get; set;}
    	public Decimal minScore {get; set;}
    	public Decimal maxScore {get; set;}
    	
    }    
     
}