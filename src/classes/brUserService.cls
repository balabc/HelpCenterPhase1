public with sharing class brUserService {
	
	public static Integer getUserCount(Id communityId) {
		
		return brUserServiceSelector.getUserMembers(communityId, 50000).size();
		
	}
	
    public static List<brLeaderboardModel> getUserLeaderboard(Id communityId) {
    	
    	List<brLeaderboardModel> leaderboardModels = new List<brLeaderboardModel>();
    	List<NetworkMember> userMembers = brUserServiceSelector.getUserMembers(communityId, 5);
    	Set<Id> memberIds = new Set<Id>();
    	
    	for (NetworkMember userMember : userMembers) {
    		memberIds.add(userMember.MemberId);
    	}
    	
    	Boolean isTop5 = false;
    	
    	if (memberIds.contains(UserInfo.getUserId())) {
    		isTop5 = true;
    	}
    	
    	
    	List<ReputationLevel> userReputationLevels = brUserServiceSelector.getUserReputationLevels(communityId);    	
    	List<brUserReputationWrap> userReputationList = new List<brUserReputationWrap>();
    	
    	for (Integer i = 0; i < userReputationLevels.size(); i++) {
    		brUserReputationWrap obj = new brUserReputationWrap();   		
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
    	
    	List<User> userMembersPhotoUrl = new List<User>();    	
    	
    	if(isTop5) {
    		userMembers = brUserServiceSelector.getUserMembers(communityId, 6);
    		memberIds.clear();
    		
	    	for (NetworkMember userMember : userMembers) {
	    		memberIds.add(userMember.MemberId);
	    	}
    	    		
    		userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);
    	} else {
			List<NetworkMember> netMember = brUserServiceSelector.getLogUserMember(communityId);
			
			if (netMember.size() > 0) {		
				userMembers = brUserServiceSelector.getUserMembers(communityId, 5);
				userMembers.addall(netMember);	
				memberIds.clear();
					
		    	for (NetworkMember userMember : userMembers) {
		    		memberIds.add(userMember.MemberId);
		    	}		
		    	
		    	userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);	    			
			} else {
				userMembers = brUserServiceSelector.getUserMembers(communityId, 6);
		    	for (NetworkMember userMember : userMembers) {
		    		memberIds.add(userMember.MemberId);
		    	}
	    	    		
	    		userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);				
			} 		  		
    	}

    	for (NetworkMember userMember : userMembers) {    		
    		brLeaderboardModel lbm = new brLeaderboardModel();
    		lbm.name = userMember.Member.Name;
    		lbm.score = String.valueOf(userMember.ReputationPoints);
    		lbm.id = String.valueOf(userMember.MemberId);
    		
    		if (userMember.MemberId == UserInfo.getUserId()) {
    			lbm.logUser = true;
    		} else {
    			lbm.logUser = false;
    		}
    		
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
    
    public class brUserReputationWrap {
    	
    	public String label {get; set;}
    	public Decimal minScore {get; set;}
    	public Decimal maxScore {get; set;}
    	
    }    
     
}