@IsTest
private class brMainNavMenuCtrlTest {
    @isTest
    static void testGetLabels() {
        Test.startTest();

        List<String> labels = brMainNavMenuCtrl.getLabels();

        Test.stopTest();

        System.assertEquals('Test', labels[0], 'wrong labels');

    }
}