public with sharing class brCommunitySpotlightCtrl {

    /**
     * Returns user information
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @return      user information
     * @see         brCommunitySpotlightModel
     */
    @AuraEnabled
    public static brCommunitySpotlightModel getUserInfo(Id userId) {
        userId = (userId == null)? UserInfo.getUserId(): userId;
        Id communityId = Network.getNetworkId();
        brCommunitySpotlightModel user = brCommunitySpotlightService.getUserInfo(userId, communityId);
        return user;
    }

}