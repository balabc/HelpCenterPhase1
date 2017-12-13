public with sharing class brCommunitySpotlightServiceSelector {

    public static List<NetworkMember> getUserMember(Id userId, Id communityId) {
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

        return null;
    }

    public static Integer getUserCountPosts(Id userId, Id communityId) {
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

        return 0;
    }

    public static Integer getUserCountComments(Id userId, Id communityId) {
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

        return 0;
    }

    public static Integer getUserCountLikes(Id userId, Id communityId) {
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

        return 0;
    }

    public static List<User> getUserMemberPhotoUrl(Id userId) {
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

        return null;
    }

}