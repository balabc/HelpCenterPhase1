@isTest
private class brAlgoliaSearchTest {

    @isTest
    static void tMethod() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            brAlgoliaSearchCtrl.getApiKey();
        }

        Test.stopTest();
    }

}