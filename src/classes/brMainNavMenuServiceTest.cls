@IsTest
private class brMainNavMenuServiceTest {
    @isTest
    static void testGetLabels() {
        Test.startTest();

        List<String> labels = brMainNavMenuService.getLabels();

        Test.stopTest();

        System.assertEquals('Test', labels[0], 'wrong labels');

    }
}