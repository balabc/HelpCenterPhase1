@IsTest
private class brMainNavMenuServiceTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testGetLabels() {
        Test.startTest();

        User user = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', user.UserName, 'wrong username');

        System.runAs(user) {
            List<String> labels = brMainNavMenuService.getLabels();
            System.assertEquals('Test', labels[0], 'wrong labels');
        }

        Test.stopTest();
    }
}