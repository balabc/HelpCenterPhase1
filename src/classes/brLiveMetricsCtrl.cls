public with sharing class brLiveMetricsCtrl {
	
    /**
     * Returns users count
     *
     * {@inheritDoc}
     *
     * @param       networkId	String  community id
     * @return      users count
     * @see         Integer
     */
	@AuraEnabled
	public static Integer getUserCount(String networkId) {
		return brUserService.getUserCount(networkId);
	}
	
    /**
     * Returns ideas count
     *
     * {@inheritDoc}
     *
     * @param       networkId	String  community id
     * @return      users count
     * @see         Integer
     */
	@AuraEnabled
	public static Integer getIdeaCount(String networkId) {
		return brIdeaService.getIdeaCount(networkId);
	}	
	
    /**
     * Returns feed items count
     *
     * {@inheritDoc}
     *
     * @return      feed items count
     * @see         Integer
     */
	@AuraEnabled
	public static Integer getFeedItemCount() {
		return brFeedItemService.getFeedItemCount();
	}	
	
    /**
     * Returns community id
     *
     * {@inheritDoc}
     *
     * @return      community id
     * @see         Id
     */
	@AuraEnabled
	public static Id getCommunityId() {
		return Network.getNetworkId();
	}  
      
}