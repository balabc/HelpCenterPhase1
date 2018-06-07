
@IsTest
private class brMenuListViewCtrlTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    private static void testBehavior() {

        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            brMenuListViewCtrl menuCtrl = new brMenuListViewCtrl();
            System.assertNotEquals(null, menuCtrl.navItems);
            System.assertEquals(false, menuCtrl.navItems.isEmpty());
        }
        Test.stopTest();
    }
}