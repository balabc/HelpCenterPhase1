public with sharing class brCommunitySpotlightService {

    /**
     * Returns user information
     *
     * {@inheritDoc}
     *
     * @param       userId	String
     * @param       communityId	String
     * @return      user information
     * @see         brCommunitySpotlightModel
     */
    public static brCommunitySpotlightModel getUserInfo(String userId, Id communityId) {
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'Name'});
        brSecurityService.performAccessCheck('read', 'NetworkMember', new List<String>{'MemberId','ReputationPoints','NetworkId'});
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'FullPhotoUrl','SmallPhotoUrl','MediumPhotoUrl','Name'});
        brSecurityService.performAccessCheck('read', 'ChatterActivity', new List<String>{'PostCount','ParentId','NetworkId'});
        brSecurityService.performAccessCheck('read', 'ChatterActivity', new List<String>{'CommentCount','ParentId','NetworkId'});
        brSecurityService.performAccessCheck('read', 'ChatterActivity', new List<String>{'LikeReceivedCount','ParentId','NetworkId'});

        brCommunitySpotlightModel user = new brCommunitySpotlightModel();
        List<NetworkMember> nUser = brCommunitySpotlightServiceSelector.getUserMember(userId, communityId);
        if (nUser.size() > 0) {
            List<User> sUser = brCommunitySpotlightServiceSelector.getUserMemberPhotoUrl(userId);

            user.id = String.valueOf(sUser[0].Id);
            user.name = String.valueOf(nUser[0].Member.Name);
            user.score = Integer.valueOf(nUser[0].ReputationPoints);
            user.sPhotoUrl = String.valueOf(sUser[0].SmallPhotoUrl);
            user.mPhotoUrl = String.valueOf(sUser[0].MediumPhotoUrl);
            user.fPhotoUrl = String.valueOf(sUser[0].FullPhotoUrl);

            List<ReputationLevel> userReputationLevels = brUserServiceSelector.getUserReputationLevels(communityId);
            List<brUserService.brUserReputationWrap> userReputationList = new List<brUserService.brUserReputationWrap>();

            for (Integer i = 0; i < userReputationLevels.size(); i++) {
                brUserService.brUserReputationWrap obj = new brUserService.brUserReputationWrap();
                if (i != userReputationLevels.size() - 1) {
                    obj.label = userReputationLevels[i].Label;
                    obj.minScore = userReputationLevels[i].Threshold;
                    obj.maxScore = userReputationLevels[i + 1].Threshold;
                } else {
                    obj.label = userReputationLevels[i].Label;
                    obj.minScore = userReputationLevels[i].Threshold;
                }
                userReputationList.add(obj);
            }
            for (Integer i = 0; i < userReputationList.size(); i++) {
                if (user.score >= userReputationList[i].minScore && user.score < userReputationList[i].maxScore) {
                    user.authority = userReputationLevels[i].Label;
                    break;
                }
            }

            user.posts = brCommunitySpotlightServiceSelector.getUserCountPosts(userId, communityId);
            user.comments = brCommunitySpotlightServiceSelector.getUserCountComments(userId, communityId);
            user.likes = brCommunitySpotlightServiceSelector.getUserCountLikes(userId, communityId);

            return user;
        }
        return null;
    }

}