public with sharing class brLiveMetricsCtrl {
	
    /**
     * Returns users count
     *
     * {@inheritDoc}
     *
     * @return      users count
     * @see         Integer
     */
	@AuraEnabled
	public static Integer getUserCount() {
		return brUserService.getUserCount();
	}
	
    /**
     * Returns ideas count
     *
     * {@inheritDoc}
     *
     * @return      users count
     * @see         Integer
     */
	@AuraEnabled
	public static Integer getIdeaCount() {
		return brIdeaService.getIdeaCount();
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
     *
     *
     * @return user name
     */
    @AuraEnabled
    public static String getCurrentUserName() {
        String userName = '';

		if(UserInfo.getUserType() == 'Guest') {
            return userName;

        } else {
            userName = String.isNotBlank(UserInfo.getFirstName()) ? UserInfo.getFirstName() : UserInfo.getLastName();

            return ' ' + userName;
        }
    }
}