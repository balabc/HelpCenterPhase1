@IsTest
private class brMainNavMenuAltCtrlTest {
    @isTest
    static void testGetLabels() {
        Test.startTest();

        List<String> labels = brMainNavMenuAltCtrl.getLabels();

        Test.stopTest();

        System.assertEquals('Test', labels[0], 'wrong labels');

    }
}