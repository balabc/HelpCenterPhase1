@IsTest
private class brAnnouncementBlockCtrlTest {
    @isTest
    static void testGetAnnouncement() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            brCommunityMetadata__mdt communityMetadata = brAnnouncementBlockCtrl.getAnnouncement();
            System.assertNotEquals(null, communityMetadata, 'metadata is not exist');
        }

        Test.stopTest();
    }
}