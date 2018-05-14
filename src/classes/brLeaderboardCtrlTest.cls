@isTest
private class brLeaderboardCtrlTest {

    static testMethod void testgetUserLeaderboard() {

        List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];

        brLeaderboardModel blm = new brLeaderboardModel();
        blm.name = 'test';
        blm.id = '1test';
        blm.logUser = true;
        blm.photoUrl = 'test';
        blm.reputationLevel = 'test';
        blm.score = 'test';

        Test.startTest();
        if (userMembers.size() > 0) {
            brLeaderboardCtrl.getUserLeaderboard();
        }

        brUserService.getUserCount();
        brUserService.getUserInfo();
        brUserService.brUserReputationWrap asd = new brUserService.brUserReputationWrap();

        brLeaderboardCtrl.getCommunityId();
        Test.stopTest();
    }

}