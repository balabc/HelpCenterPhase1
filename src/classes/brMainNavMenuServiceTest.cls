@IsTest
private class brMainNavMenuServiceTest {
    @isTest
    static void testGetLabels() {
        Test.startTest();

        User user = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', user.UserName, 'wrong username');

        System.runAs(user) {
            List<String> labels = brMainNavMenuService.getLabels();
            System.assertEquals('Test', labels[0], 'wrong labels');
        }

        Test.stopTest();
    }
}