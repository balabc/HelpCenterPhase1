public with sharing class brLeaderboardCtrl{
	
	public static List<brLeaderboardModel> getUserLeaderboard() {
		
		return brUserService.getUserLeaderboard();
		
	} 
	
}