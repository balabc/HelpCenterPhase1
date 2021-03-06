public with sharing class brCommunitySpotlightServiceSelector {

    /**
     * Returns user member
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @param       communityId	String
     * @return      list user member
     * @see         List<NetworkMember>
     */
    public static List<NetworkMember> getUserMember(String userId, Id communityId) {
        try {
            if (userId != null) {
                List<NetworkMember> userMember = [
                        SELECT
                                MemberId,
                                Member.Name,
                                ReputationPoints
                        FROM
                                NetworkMember
                        WHERE
                        (NetworkId = :communityId) AND
                        (MemberId = :userId)
                        LIMIT 1
                ];
                return userMember;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return null;
    }

    /**
     * Returns count posts by user id and community id
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @param       communityId	String
     * @return      count posts
     * @see         Integer
     */
    public static Integer getUserCountPosts(String userId, Id communityId) {
        try {
            if (userId != null) {
                List<AggregateResult> countPosts = [
                        SELECT
                                SUM(PostCount)
                        FROM
                                ChatterActivity
                        WHERE
                        (ParentId = :userId) AND
                        (NetworkId = :communityId)
                ];
                return Integer.valueOf(countPosts[0].get('expr0'));
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return 0;
    }

    /**
     * Returns count comments by user id and community id
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @param       communityId	String
     * @return      count comments
     * @see         Integer
     */
    public static Integer getUserCountComments(String userId, Id communityId) {
        try {
            if (userId != null) {
                List<AggregateResult> countPosts = [
                        SELECT
                                SUM(CommentCount)
                        FROM
                                ChatterActivity
                        WHERE
                        (ParentId = :userId) AND
                        (NetworkId = :communityId)
                ];
                return Integer.valueOf(countPosts[0].get('expr0'));
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return 0;
    }

    /**
     * Returns count likes by user id and community id
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @param       communityId	String
     * @return      count likes
     * @see         Integer
     */
    public static Integer getUserCountLikes(String userId, Id communityId) {
        try {
            if (userId != null) {
                List<AggregateResult> countPosts = [
                        SELECT
                                SUM(LikeReceivedCount)
                        FROM
                                ChatterActivity
                        WHERE
                        (ParentId = :userId) AND
                        (NetworkId = :communityId)
                ];
                return Integer.valueOf(countPosts[0].get('expr0'));
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return 0;
    }

    /**
     * Returns user photos
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @return      list user photos
     * @see         List<User>
     */
    public static List<User> getUserMemberPhotoUrl(String userId) {
        try {
            if (userId != null) {
                List<User> userMember = [
                        SELECT
                                Id,
                                FullPhotoUrl,
                                SmallPhotoUrl,
                                MediumPhotoUrl,
                                Name
                        FROM
                                User
                        WHERE
                                Id = :userId
                        LIMIT 1
                ];
                return userMember;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return null;
    }

}