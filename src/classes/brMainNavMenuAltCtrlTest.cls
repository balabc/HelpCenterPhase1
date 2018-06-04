@IsTest
private class brMainNavMenuAltCtrlTest {
    @isTest
    static void testGetLabels() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            List<String> labels = brMainNavMenuAltCtrl.getLabels();
            System.assertEquals('Test', labels[0], 'wrong labels');
        }

        Test.stopTest();

    }
}