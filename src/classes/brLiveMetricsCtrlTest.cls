@isTest
private class brLiveMetricsCtrlTest {

    @TestSetup
    static void setup() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        Test.stopTest();
    }

    @isTest
    static void brLiveMetricsCtrlTest() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            FeedItem fi = new FeedItem();
            fi.Title = 'Test';
            fi.Body = 'Test';
            fi.ParentId = UserInfo.getUserId();
            fi.Type = 'QuestionPost';
            fi.Visibility = 'AllUsers';
            insert fi;

            brLiveMetricsCtrl.getIdeaCount();
            brIdeaService.getIdeaCount();
            brIdeaServiceSelector.getIdeaList(null);
            brIdeaServiceSelector.getZoneList();
            brLiveMetricsCtrl.getFeedItemCount();
            List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];
            if (userMembers.size() > 0) {
                brLiveMetricsCtrl.getUserCount();
            }
        }
        Test.stopTest();
    }

    @isTest
    static void testGetCurrentUserName() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String userName = brLiveMetricsCtrl.getCurrentUserName();
            System.assertEquals(' Baker', userName, 'result without current user');
        }
        Test.stopTest();
    }
}