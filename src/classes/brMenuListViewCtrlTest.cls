
@IsTest
private class brMenuListViewCtrlTest {
    @isTest
    private static void testBehavior() {

        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            brMenuListViewCtrl menuCtrl = new brMenuListViewCtrl();
            System.assertNotEquals(null, menuCtrl.navItems);
            System.assertEquals(false, menuCtrl.navItems.isEmpty());
        }
        Test.stopTest();
    }
}