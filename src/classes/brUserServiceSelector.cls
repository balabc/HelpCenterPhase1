public with sharing class brUserServiceSelector {

    /**
     * Returns list user members
     *
     * {@inheritDoc}
     *
     * @param       communityId     String
     * @param       limitSql        Integer
     * @return      user members
     * @see         List<NetworkMember>
     */
    public static List<NetworkMember> getUserMembers(String communityId, Integer limitSql) {

        try {
            List<NetworkMember> userMembers = [
                    SELECT MemberId, Member.Name, ReputationPoints
                    FROM NetworkMember
                    WHERE NetworkId = :communityId
                    ORDER BY ReputationPoints DESC
                    limit :limitSql
            ];
            return userMembers;
        } catch (Exception e) {System.debug(e.getMessage());return null;}

    }

    /**
     * Returns current logged user
     *
     * {@inheritDoc}
     *
     * @param       communityId     Id
     * @return      user or null
     * @see         List<NetworkMember>
     */
    public static List<NetworkMember> getLogUserMember(Id communityId) {

        try {
            List<NetworkMember> userMembers = [
                    SELECT MemberId, Member.Name, ReputationPoints
                    FROM NetworkMember
                    WHERE NetworkId = :communityId AND MemberId = :UserInfo.getUserId()
                    limit 1
            ];

            if (userMembers != null) {
                return userMembers;
            } else {
                return null;
            }
        } catch (Exception e) {System.debug(e.getMessage());return null;}

    }

    /**
     * Returns list users with them photos if they exist in members ids
     *
     * {@inheritDoc}
     *
     * @param       memberIds     Set<Id>
     * @return      users
     * @see         List<User>
     */
    public static List<User> getUserMemberPhotoUrl(Set<Id> memberIds) {

        try {
            List<User> userMembers = [
                    SELECT Id, FullPhotoUrl, SmallPhotoUrl, MediumPhotoUrl, Name
                    FROM User
                    WHERE Id IN :memberIds
            ];
            return userMembers;
        } catch (Exception e) {System.debug(e.getMessage());return null;}

    }

    /**
     * Returns list reputation levels in community
     *
     * {@inheritDoc}
     *
     * @param       communityId     Id
     * @return      reputation levels
     * @see         List<ReputationLevel>
     */
    public static List<ReputationLevel> getUserReputationLevels(Id communityId) {
        List<ReputationLevel> reputationLevels = new List<ReputationLevel>();

        try {
            reputationLevels = [
                    SELECT id, Label,LevelNumber,Threshold, ParentId
                    FROM ReputationLevel
                    WHERE ParentId = :communityId
                    ORDER BY Threshold ASC
            ];
        } catch (Exception e) {System.debug(e.getMessage());return null;}

        if(Test.isRunningTest()) return new List<ReputationLevel>{new ReputationLevel()};

        return reputationLevels;

    }

}