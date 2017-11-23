@isTest
private class brLeaderboardCtrlTest {
	
    static testMethod void testgetUserLeaderboard() {
    	
    	List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];  
    	
    	if (userMembers.size() > 0) {
    		brLeaderboardCtrl.getUserLeaderboard(userMembers[0].NetworkId);
    	}  	
    	
    	brLeaderboardCtrl.getCommunityId();
    	        
    }
    
}