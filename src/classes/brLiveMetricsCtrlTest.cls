@isTest
private class brLiveMetricsCtrlTest {

    static testMethod void brLiveMetricsCtrlTest() {
        
        brLiveMetricsCtrl.getCommunityId();
        brLiveMetricsCtrl.getIdeaCount(null);
        brLiveMetricsCtrl.getFeedItemCount();
    	List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];      	    	
    	if (userMembers.size() > 0) {   		
    		brLiveMetricsCtrl.getUserCount(userMembers[0].NetworkId);    		
    	}  	     
    	   	                
    }
}