public with sharing class brLeaderboardCtrl{
	
	@AuraEnabled
	public static List<brLeaderboardModel> getUserLeaderboard(Id communityId) {	 	
		return brUserService.getUserLeaderboard(communityId);		
	} 	
	
	@AuraEnabled
	public static Id getCommunityId() {
		return Network.getNetworkId();
	}	
	
}