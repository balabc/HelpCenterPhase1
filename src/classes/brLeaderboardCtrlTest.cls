@isTest
private class brLeaderboardCtrlTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @IsTest
    static void testgetUserLeaderboard() {
        Test.startTest();

        User user = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', user.UserName, 'wrong username');

        System.runAs(user) {

            List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];

            brLeaderboardModel blm = new brLeaderboardModel();
            blm.name = 'test';
            blm.id = '1test';
            blm.logUser = true;
            blm.photoUrl = 'test';
            blm.reputationLevel = 'test';
            blm.score = 'test';

            if (userMembers.size() > 0) {
                brLeaderboardCtrl.getUserLeaderboard();
            }

            brUserService.getUserCount();
            brUserService.getUserInfo();
            brUserService.brUserReputationWrap asd = new brUserService.brUserReputationWrap();

            brLeaderboardCtrl.getCommunityId();
        }
        Test.stopTest();
    }

}