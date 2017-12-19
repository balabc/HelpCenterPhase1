public with sharing class brLeaderboardCtrl {

    /**
     * Returns list leaderboard
     *
     * {@inheritDoc}
     *
     * @param       communityId     Id
     * @return      leaderboards
     * @see         List<brLeaderboardModel>
     */
    @AuraEnabled
    public static List<brLeaderboardModel> getUserLeaderboard(Id communityId) {
        return brUserService.getUserLeaderboard(communityId);
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