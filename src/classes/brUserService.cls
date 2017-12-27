public with sharing class brUserService {

    /**
     * Returns user information
     *
     * {@inheritDoc}
     *
     * @return      user information
     * @see         brLeaderboardModel
     */
    public static brLeaderboardModel getUserInfo() {
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'FullPhotoUrl','SmallPhotoUrl','MediumPhotoUrl','Name'});

        Set<id> usersId = new Set<id>();
        usersId.add(UserInfo.getUserId());
        List<User> users = brUserServiceSelector.getUserMemberPhotoUrl(usersId);
        if (users.size() > 0) {
            brLeaderboardModel lbm = new brLeaderboardModel();
            lbm.id = users[0].id;
            lbm.name = users[0].Name;
            lbm.photoUrl = users[0].SmallPhotoUrl;
            return lbm;
        }

        return null;

    }

    /**
     * Returns count users in community
     *
     * {@inheritDoc}
     *
     * @param       communityId     Id
     * @return      count users
     * @see         Integer
     */
    public static Integer getUserCount(Id communityId) {
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'Name'});
        brSecurityService.performAccessCheck('read', 'NetworkMember', new List<String>{'MemberId','ReputationPoints','NetworkId'});

        return brUserServiceSelector.getUserMembers(communityId, 50000).size();

    }

    /**
     * Returns list leaderboard
     *
     * {@inheritDoc}
     *
     * @param       communityId     Id
     * @return      leaderboards
     * @see         List<brLeaderboardModel>
     */
    public static List<brLeaderboardModel> getUserLeaderboard(Id communityId) {
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'Name'});
        brSecurityService.performAccessCheck('read', 'NetworkMember', new List<String>{'MemberId','ReputationPoints','NetworkId'});
        brSecurityService.performAccessCheck('read', 'ReputationLevel', new List<String>{'Label','LevelNumber','Threshold','ParentId'});
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'FullPhotoUrl','SmallPhotoUrl','MediumPhotoUrl','Name'});
        brSecurityService.performAccessCheck('read', 'ReputationLevel', new List<String>{'Label','LevelNumber','Threshold','ParentId'});

        List<brLeaderboardModel> leaderboardModels = new List<brLeaderboardModel>();
        List<NetworkMember> userMembers = brUserServiceSelector.getUserMembers(communityId, 5);
        Set<Id> memberIds = new Set<Id>();

        for (NetworkMember userMember : userMembers) {
            memberIds.add(userMember.MemberId);
        }

        Boolean isTop5 = false;

        if (memberIds.contains(UserInfo.getUserId())) {
            isTop5 = true;
        }


        List<ReputationLevel> userReputationLevels = brUserServiceSelector.getUserReputationLevels(communityId);
        List<brUserReputationWrap> userReputationList = new List<brUserReputationWrap>();

        for (Integer i = 0; i < userReputationLevels.size(); i++) {
            brUserReputationWrap obj = new brUserReputationWrap();
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

        List<User> userMembersPhotoUrl = new List<User>();

        if (isTop5) {
            userMembers = brUserServiceSelector.getUserMembers(communityId, 6);
            memberIds.clear();

            for (NetworkMember userMember : userMembers) {
                memberIds.add(userMember.MemberId);
            }

            userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);
        } else {
            List<NetworkMember> netMember = brUserServiceSelector.getLogUserMember(communityId);

            if (netMember.size() > 0) {
                userMembers = brUserServiceSelector.getUserMembers(communityId, 5);
                userMembers.addall(netMember);
                memberIds.clear();

                for (NetworkMember userMember : userMembers) {
                    memberIds.add(userMember.MemberId);
                }

                userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);
            } else {
                userMembers = brUserServiceSelector.getUserMembers(communityId, 6);
                for (NetworkMember userMember : userMembers) {
                    memberIds.add(userMember.MemberId);
                }

                userMembersPhotoUrl = brUserServiceSelector.getUserMemberPhotoUrl(memberIds);
            }
        }
        for (NetworkMember userMember : userMembers) {
            brLeaderboardModel lbm = new brLeaderboardModel();
            lbm.name = userMember.Member.Name;
            lbm.score = String.valueOf(userMember.ReputationPoints);
            lbm.id = String.valueOf(userMember.MemberId);

            if (userMember.MemberId == UserInfo.getUserId()) {
                lbm.logUser = true;
            } else {
                lbm.logUser = false;
            }

            for (User us : userMembersPhotoUrl) {
                if (userMember.MemberId == us.id) {
                    lbm.photoUrl = us.MediumPhotoUrl;//FullPhotoUrl//SmallPhotoUrl
                    break;
                }
            }

            for (Integer i = 0; i < userReputationList.size(); i++) {
                if (userReputationList[i].maxScore != null) {
                    if (userMember.ReputationPoints >= userReputationList[i].minScore && userMember.ReputationPoints < userReputationList[i].maxScore) {
                        lbm.reputationLevel = userReputationLevels[i].Label;
                    }
                } else {
                    if (userMember.ReputationPoints >= userReputationList[i].minScore) {
                        lbm.reputationLevel = userReputationLevels[i].Label;
                    }
                }
            }
            leaderboardModels.add(lbm);
        }

        return leaderboardModels;

    }

    public class brUserReputationWrap {

        /**
         * label
         */
        public String label { get; set; }

        /**
         * minimum score
         */
        public Decimal minScore { get; set; }

        /**
         * maximum score
         */
        public Decimal maxScore { get; set; }

    }

}