@IsTest
private class brAnnouncementBlockCtrlTest {
    @isTest
    static void testGetAnnouncement() {
        Test.startTest();

        brCommunityMetadata__mdt communityMetadata = brAnnouncementBlockCtrl.getAnnouncement();

        Test.stopTest();

        System.assertNotEquals(null, communityMetadata, 'metadata is not exist');
    }
}