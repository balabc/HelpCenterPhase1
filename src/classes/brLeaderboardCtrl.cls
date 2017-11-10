public with sharing class brLeaderboardCtrl{
	@AuraEnabled
	public static List<brLeaderboardModel> getUserLeaderboard() {
		
		return brUserService.getUserLeaderboard();
		
	} 	
}