@IsTest
private class brGuidesListCtrlTest {
    @isTest
    static void testGetGuideArticles() {
        Test.startTest();

        List<brGuideItem__mdt> guideItems = brGuidesListCtrl.getGuideArticles();

        Test.stopTest();

        System.assertEquals(3, guideItems.size(), 'wrong number of guide articles');
    }
}