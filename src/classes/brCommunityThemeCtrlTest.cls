@IsTest
private class brCommunityThemeCtrlTest {
    @isTest
    static void testGetAnnouncementWithout() {
        Test.startTest();

        String message = brCommunityThemeCtrl.getAnnouncement();

        Test.stopTest();

        System.assertEquals('test portal notice', message, 'wrong message');
    }
}