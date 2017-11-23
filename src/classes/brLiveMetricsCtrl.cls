public with sharing class brLiveMetricsCtrl {
	
	@AuraEnabled
	public static Integer getUserCount(String networkId) {
		return brUserService.getUserCount(networkId);
	}
	
	@AuraEnabled
	public static Integer getIdeaCount(String networkId) {
		return brIdeaService.getIdeaCount(networkId);
	}	
	
	@AuraEnabled
	public static Integer getFeedItemCount() {
		return brFeedItemService.getFeedItemCount();
	}	
	
	@AuraEnabled
	public static Id getCommunityId() {
		return Network.getNetworkId();
	}  
      
}