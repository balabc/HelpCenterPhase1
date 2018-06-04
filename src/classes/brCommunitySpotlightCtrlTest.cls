@isTest
private class brCommunitySpotlightCtrlTest {

    @isTest
    static void testCommunitySpotlight() {

        List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];

        brLeaderboardModel blm = new brLeaderboardModel();
        blm.name = 'test';
        blm.id = '1test';
        blm.logUser = true;
        blm.photoUrl = 'test';
        blm.reputationLevel = 'test';
        blm.score = 'test';

        User newUs = new User();
        newUs.id = userMembers[0].MemberId;

        Test.startTest();

        System.runAs(newUs) {
            brCommunitySpotlightCtrl.getUserInfo(UserInfo.getUserId());
            brCommunitySpotlightService.getUserInfo(UserInfo.getUserId(), userMembers[0].NetworkId);
        }

        Test.stopTest();

    }

}