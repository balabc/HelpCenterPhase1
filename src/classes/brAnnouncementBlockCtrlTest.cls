@IsTest
private class brAnnouncementBlockCtrlTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testGetAnnouncement() {
        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            brCommunityMetadata__mdt communityMetadata = brAnnouncementBlockCtrl.getAnnouncement();
            System.assertNotEquals(null, communityMetadata, 'metadata is not exist');
        }

        Test.stopTest();
    }
}