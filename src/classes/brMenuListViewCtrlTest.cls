
@IsTest
private class brMenuListViewCtrlTest {
    static testMethod void testBehavior() {

        Test.startTest();
            brMenuListViewCtrl menuCtrl = new brMenuListViewCtrl();
        Test.stopTest();

        System.assertNotEquals(null, menuCtrl.navItems);
        System.assertEquals(false, menuCtrl.navItems.isEmpty());

    }
}