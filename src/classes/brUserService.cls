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
    		
    		for (Integer i = 0; i < userReputationLevels.size(); i++) {
    			if (i == 0) {
					if (userMember.ReputationPoints > userReputationLevels[i].Threshold && userMember.ReputationPoints < userReputationLevels[i + 1].Threshold) {
						lbm.reputationLevel =  userReputationLevels[i].Label;
						break;
					}
    			} else {
	    			if (userMember.ReputationPoints < userReputationLevels[i].Threshold && userMember.ReputationPoints > userReputationLevels[i - 1].Threshold) {    			
	    				lbm.reputationLevel =  userReputationLevels[i].Label;
	    				break;
	    			}    				
    			}
    		}
    		
    		leaderboardModels.add(lbm);
    	}
    	
    	return leaderboardModels;
    	
    }
    
}