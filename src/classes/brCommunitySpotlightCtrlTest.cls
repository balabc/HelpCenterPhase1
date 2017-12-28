@isTest
private class brCommunitySpotlightCtrlTest {

    static testMethod void testCommunitySpotlight() {

        List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];
        //List<NetworkMember> userMembers = [SELECT Id FROM User];

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

        List<User> users = [SELECT id FROM User WHERE Id = '0050O000007Bckb'];
        System.runAs(users[0]) {
            List<brFeedItemModel> ad = brFeedItemService.getQuestions();
        }

        Test.stopTest();

    }

}